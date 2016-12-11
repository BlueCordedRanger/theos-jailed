#!/bin/bash

source "$STAGE"

bundle_id=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$appdir/Info.plist")
product_name="${bundle_id##*.}"

r=$(tput sgr0)
b=$(tput bold)
n=$'\n'
function add { capabilities="$capabilities$n>>> $b$1$r"; }

entitlements=$(codesign -d --entitlements - "$appdir" 2>/dev/null)
if [[ $? != 0 ]]; then
	error "Failed to get entitlements for $app"
fi

for ent in $(echo "$entitlements" | grep "<key>"); do
	case $(echo "$ent" | cut -f2 -d\> | cut -f1 -d\<) in
		com.apple.developer.networking.vpn.api)
			add "Personal VPN";;
		com.apple.external-accessory.wireless-configuration)
			add "Wireless Accessory Configuration";;
		com.apple.developer.homekit)
			add "HomeKit";;
		com.apple.developer.healthkit)
			add "HealthKit";;
		inter-app-audio)
			add "Inter-App Audio";;
		com.apple.developer.siri)
			add "Siri";;
		com.apple.security.application-groups)
			add "App Groups";;
		com.apple.developer.pass-type-identifiers)
			add "Wallet";;
		com.apple.developer.default-data-protection)
			add "Data Protection";;
		com.apple.developer.icloud*)
			add "iCloud (requires extra configuration)";;
	esac
done

if [[ -n $capabilities ]]; then
	capabilities="$(cat <<ENT
12. Select the ${b}Capabilities$r tab to the right of ${b}General$r.
13. Enable the following capabilities (ignore any that give you an error):
$capabilities
ENT)$n"
fi

eval "less -R <<EOF$n$(<$INFO_TEMPLATE)"
