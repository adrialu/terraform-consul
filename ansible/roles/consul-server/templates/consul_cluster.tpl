{
	"server": true,
	"datacenter": "skyhigh",
  "data_dir": "/var/consul",
	"bootstrap_expect": {{ groups['consul'] | length }},
	"retry_join": [{% for host in groups['consul'] %}"{{ hostvars[host].ansible_default_ipv4.address }}"{{ ", " if not loop.last else "" }}{% endfor %}],
	"client_addr": "0.0.0.0",
	"ports": {
		"dns": 53
	},
	"enable_syslog": true,
	"ui": true
}
