#!/bin/sh
 : ${1:?"Must specify an action ('release', 'set-version', 'broadcast', 'broadcast-freeform')"}
 : ${2:?"Must specify release version. Ex: 2.0.1.Final"}

ACTION=$1
RELEASED_VERSION=$2

if [ "$ACTION" = "release" ]; then
	curl -X POST \
		-H "consumer_key: 612a03501e1e62e0f0f67f656b727e50" \
		-H "consumer_token: 0643c1b98def1c852448377261c3101616f29a1e3cf2d2a62ccf5e32d4afea0e" \
		-H "Content-Type: application/json" \
		-H "Accept: application/json" \
		-d '{"candidate": "jbossforge", "version": "'"$RELEASED_VERSION"'", "url": "https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v='$RELEASED_VERSION'&e=zip&c=offline"}' \
		https://gvm-vendor.herokuapp.com/release

fi

if [ "$ACTION" = "set-version" ]; then
	curl -X PUT \
		-H "consumer_key: 612a03501e1e62e0f0f67f656b727e50" \
		-H "consumer_token: 0643c1b98def1c852448377261c3101616f29a1e3cf2d2a62ccf5e32d4afea0e" \
		-H "Content-Type: application/json" \
		-H "Accept: application/json" \
		-d '{"candidate": "jbossforge", "default": "'"$RELEASED_VERSION"'"}' \
		https://gvm-vendor.herokuapp.com/default
fi

if [ "$ACTION" = "broadcast" ]; then
	curl -X POST \
		-H "consumer_key: 612a03501e1e62e0f0f67f656b727e50" \
		-H "consumer_token: 0643c1b98def1c852448377261c3101616f29a1e3cf2d2a62ccf5e32d4afea0e" \
		-H "Content-Type: application/json" \
		-H "Accept: application/json" \
		-d '{"candidate": "jbossforge", "version": "'"$RELEASED_VERSION"'", "hashtag": "JBossForge"}' \
		https://gvm-vendor.herokuapp.com/announce/struct	
fi

if [ "$ACTION" = "broadcast-freeform" ]; then
	curl -X POST \
		-H "consumer_key: CONSUMER_KEY" \
		-H "consumer_token: CONSUMER_TOKEN" \
		-H "Content-Type: application/json" \
		-H "Accept: application/json" \
		-d '{"text": "'"$RELEASED_VERSION"'"}' \
		https://gvm-vendor.herokuapp.com/announce/freeform
fi
