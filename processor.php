<?php
/*
Plugin Name: Guifi Xslt Processor
Plugin URI: no uri at the moment
Description: Plugin to show guifi.net nodes from your prefered zone. Based on Chryzo, Hakre's plugin (Xslt Processor)
Version: 0.4
Author: Juane Puig
Author URI: http://www.offtic.com


This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

/*
usage:

	[GuifiProcessor zone="ID_Guifi_Zone" gmapikey="GOOGLE_MAPS_API_KEY_FOR_YOUR_SITE_DOMAIN" mapwidth="400px" mapheight="500px" supernodes="on" params="showtree=on"]
	
*		zone: required
*		gmapikey: required
*		mapwidth: optional
*		mapheight: optional 
*		supernodes: optional (default on, shows only supernodes)
*		params: showtree=on|off (default off, hides the described tree zone)

*/

add_option("CPT_Path", "");
add_option("CPT_Separator", ",");

/**
 * XmlProcessor Option retrieval
 *
 *	XML - XSLT Processor
 *
 *
 * @return array list of path to look inside to retrieve files
 */
function cpt_retrieve_option() {
	$paths = get_option("CPT_Path");
	$separator = get_option("CPT_Separator");
}
 

/**
 * XmlProcessor Shortcode Hook
 * 
 * XML - XSLT Processor
 * 
 * @param  array $atts shortcode attributes
 * @return string output of shortcode(processed xml/xslt or error message on failure)
 */
function cpt_process_xml($atts) {
	
	$options = null;
	$get =null;
	$post = null;
	$namespace = null;
	$gmapikey = null;
	$xml = false;
	$xslt = false;
	$paramSep = "|";
	$keyvalSep = "=";
	
	$xml="";
	$xslt = "wp-content/plugins/guifi-xsl-processor/cnml.xsl";

	$server = get_bloginfo('wpurl');
	
	
	$zone = $atts["zone"];
	
	// This is a separate section because we can't use the short format of the filepath in this case since the parameters may have
	// some blanks in them which would screw around with the parsing
	if (isset($atts["params"])){				// parameter for the parameters of the xsl file
		$options = $atts["params"];
	}
	if (isset($atts["get"])){
		$get = $atts["get"];
	}
	
	if (isset($atts["post"])){
		$get = $atts["post"];
	}
	
	if (isset($atts["gmapikey"])){
		$gmapikey = $atts["gmapikey"];
		$options .= $paramSep."gmapikey=".$gmapikey;
	}
	
	if (isset($atts["mapwidth"])){
		$options .= $paramSep."mapwidth=".$atts["mapwidth"];
	}
	if (isset($atts["mapheight"])){
		$options .= $paramSep."mapheight=".$atts["mapheight"];
	}
	if (isset($atts["supernodes"])){
		$options .= $paramSep."supernodes=".$atts["supernodes"];
	}

	$options .= $paramSep."server=".$server;
		
	// this will include relative to this file
	//$path = dirname(__FILE__);
	// this will include relative to this wordpress root folder
	$path = ABSPATH;
	
	$xml  = $path . $xml;
	$xslt = $path . $xslt;

	$sXml = file_get_contents('http://guifi.net/guifi/cnml/'.$zone.'/detail');
	if ($sXml !== false) {
		$sXml = join("<data><cnml", split("<cnml", $sXml));
		$sXml = $sXml."</data>";
	   //echo utf8_encode($sXml . "</data>" );
	} else {
	   // an error happened
	   die("error leyendo XML");
	}
		
	if ($gmapikey && file_exists($xslt))
	{
		$xslDoc = new DOMDocument();
		$xslDoc->load($xslt);
		
		$xmlDoc = new DOMDocument();
		$xmlDoc->loadXML($sXml);

		$proc = new XSLTProcessor();
		// setting parameters section
		// /*
		if ($options != null) {
			$options = explode($paramSep,$options);
			//print_r(count($options));
			for ($i = 0; $i< count($options); $i++){
				$pair = explode($keyvalSep, $options[$i]);
				if ( count($pair) == 1 ) {
					$proc->setParameter(null, $pair[0], "");			// just a key, then we blank the value of the parameter
				} elseif ( count($pair) == 2 ) {
					//print_r($pair);
					//$proc->setParameter(null, 'default_param', 'test');		// just a key/value pair, we replace
					$proc->setParameter(null, $pair[0], $pair[1]);		// just a key/value pair, we replace
				} elseif (count($pair) == 3 ) {
					$proc->setParameter($pair[0], $pair[1], $pair[2]);	// a namespace/key/value set, we replace
				}
			}
		}
		if ($get != null) {
			$get = explode($paramSep,$get);
			for ($i = 0; $i< count($get); $i++){
				$pair = explode($keyvalSep, $get[$i]);
				if ( count($pair) == 1 ) {
					$proc->setParameter(null, $pair[0], $_GET[$pair[0]]);	// just a key, then we blank the value of the parameter
				} elseif ( count($pair) == 2 ) {
					$proc->setParameter(null, $pair[0], $_GET[$pair[1]]);	// just a key/value pair, we replace
				} elseif (count($pair) == 3 ) {
					$proc->setParameter($pair[0], $pair[1], $_GET[$pair[2]]);// a namespace/key/value set, we replace
				}
			}
		}
		if ($post != null) {
			$post = explode($paramSep,$post);
			for ($i = 0; $i< count($post); $i++){
				$pair = explode($keyvalSep, $post[$i]);
				if ( count($pair) == 1 ) {
					$proc->setParameter(null, $pair[0], $_POST[$pair[0]]);	// just a key, then we blank the value of the parameter
				} elseif ( count($pair) == 2 ) {
					$proc->setParameter(null, $pair[0], $_POST[$pair[1]]);	// just a key/value pair, we replace
				} elseif (count($pair) == 3 ) {
					$proc->setParameter($pair[0], $pair[1], $_POST[$pair[2]]);// a namespace/key/value set, we replace
				}
			}
		}
		// */
		// end of parameter section
		$proc->importStylesheet($xslDoc);			
		return $proc->transformToXML($xmlDoc);		
	}
	
	return sprintf('<div class="error"><strong>Error processing XML and XSLT. Configuration was: %s</strong></div>', htmlspecialchars(print_r($atts, true)));	
}

function guifixslprocessor_style () {
     echo "<!-- Guifi XSL Processor -->\n";
     echo "<link rel='stylesheet' href='".get_bloginfo('wpurl')."/wp-content/plugins/guifi-xsl-processor/guifi.css' type='text/css' />\n";
     echo "<!-- /Guifi XSL Processor -->\n";
}

add_action('wp_head', 'guifixslprocessor_style');


if (function_exists("add_shortcode")){
	add_shortcode("GuifiProcessor", "cpt_process_xml");
}

?>