

node <<JS
console.log("hi")
JS

bash -c <<JS
echo hi
JS

newins <<-EOF - org.freedesktop.Notifications.service
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
EOF
