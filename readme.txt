=== Plugin Name ===
Contributors: kusinkay
Donate link: http://fundacio.guifi.net/donacions
Tags: maps, guifi, xsl, cnml, googlemaps, gmaps
Requires at least: 2.8.5
Tested up to: 2.8.5
Stable tag: 0.4

== Description ==
Plugin to show guifi.net nodes from your prefered zone. Based on Chryzo, Hakre's plugin (Xslt Processor)


== Installation ==

This section describes how to install the plugin and get it working.

1. Unzip de downloaded ZIP into your `/wp-content/plugins/` directory
2. Activate the plugin through the 'Plugins' menu in WordPress


== Frequently Asked Questions ==

= Usage =

1. Get your Google Maps API key for your domain
2. Create a new content or edit the one you want to embed a Guifi.net map into
3. Write the following intruction:
4. 		[GuifiProcessor zone="ID_Guifi_Zone" gmapikey="GOOGLE_MAPS_API_KEY_FOR_YOUR_SITE_DOMAIN" mapwidth="400px" mapheight="500px" supernodes="on" params="showtree=on"]
*		zone: required
*		gmapikey: required
*		mapwidth: optional
*		mapheight: optional 
*		supernodes: optional (default on, shows only supernodes)
*		params: showtree=on|off (default off, hides the described tree zone)

= What's the ID Guifi Zone? =

If you don't know what's the ID_Guifi_Zone go to your desired zone in www.guifi.net, checkout the CNML link you'll find at the bottom and put the number you'll find at the end of the address http://guifi.net/guifi/cnml/XXXX. Change XXXX with the given number.

== Screenshots ==

1. An interactive map allows the user to choose the state of the nodes he wants to see. The filters above allows you to filter according to the services you are interested in. At the bottom of the map you can see a list of nodes with its (active) services. Once you click at a listed node, you can see detailed information of the node.
2. Complete tree view of the nested zones, with its nodes (and its status) and its devices (and its status) can be viewed with the "showtree=on" parameter (see FAQ usage)

== Changelog ==
= 0.4 =
* shows the linked distances and highlightes the active ones


= 0.3 =
* service filters shown in columns
* Service filters and icons "games", "wol" added

= 0.2 =
* Presentation format changed (linkable tags at the bottom of the map)
* Service filters added ("DNS","SNPgraphs","NTP","web","Proxy", "iperf", "radio", "Streaming", "IM", "irc")
* Non supernodes can be diabled using "supernodes" param 
* Status "Reserved" added to filters
* Service icons "iperf", "radio", "Streaming", "IM", "irc" added



= 0.1 =
* Interactive map where you can choose the estatus of the nodes you want to see
* Links and its status ar showed in the map
* Tree map to detail 
	zone
	|-node(status)
	|	|--device(status)
	|-subzone
		|--node(status)
			|---device(status)

== Upgrade Notice ==



