#!/bin/bash

source "$STAGE" "Generating info for $(basename "$IPA")"

codesign -d --entitlements - "$appdir/$app_binary" > "$ENTITLEMENTS" 2>/dev/null
if [[ $? != 0 ]]; then
	error "Failed to get entitlements for $appdir/$app_binary"
fi

function add { ent_list="$ent_list"$'\n'"$1"; }

for ent in $(grep -a '<key>' "$ENTITLEMENTS"); do
	entitlement=$(echo $ent | cut -f2 -d\> | cut -f1 -d\<)
	case $entitlement in
		com.apple.developer.networking.vpn.api)
			add ">>> VPN Configuration & Control"
			;;
		com.apple.developer.in-app-payments)
			add ">>> Apple Pay (requires extra configuration)"
			;;
		com.apple.external-accessory.wireless-configuration)
			add ">>> Wireless Accessory Configuration"
			;;
		com.apple.developer.homekit)
			add ">>> HomeKit"
			;;
		com.apple.security.application-groups)
			add ">>> App Groups:"
			for group in $(dd if="$ENTITLEMENTS" bs=1 skip=8 2>/dev/null | sed -ne '/application-groups/,/<\/array/p' | grep '<string>' 2>/dev/null); do
				group_id=$(echo $group | cut -f2 -d\> | cut -f1 -d\<)-patched
				add "    $group_id"
			done
			;;
		com.apple.developer.associated-domains)
			add ">>> Associated Domains:"
			for group in $(dd if="$ENTITLEMENTS" bs=1 skip=8 2>/dev/null | sed -ne '/associated-domains/,/<\/array/p' | grep '<string>' 2>/dev/null); do
				group_id=$(echo $group | cut -f2 -d: | cut -f1 -d\<)
				add "    $group_id"
			done
			;;
		com.apple.developer.healthkit)
			add ">>> HealthKit"
			;;
		inter-app-audio)
			add ">>> Inter-App Audio"
			;;
		com.apple.developer.ubiquity*)
			add ">>> Passbook"
			add ">>> iCloud (requires extra configuration)"
			add ">>> Data Protection"
			;;
	esac
done

ent_list="$(echo "$ent_list" | sed -e :a -e '/./,$!d;/^\n*$/{$d;N;};/\n$/ba')" # Remove extra newlines
[[ -n $ent_list ]] && ent_list=$'\n'"$ent_list"$'\n' # Add newline padding if ent_list isn't empty

eval "less <<EOF
$(<$INFO_TEMPLATE)" 2> /dev/null
