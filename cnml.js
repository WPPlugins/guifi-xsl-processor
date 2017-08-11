Array.prototype.has = function(value) {
	var i;
	for (var i = 0, loopCnt = this.length; i < loopCnt; i++) {
		if (this[i] === value) {
			return true;
		}
	}
	return false;
};

Array.prototype.hasone = function(value){
	for(var i=0; i<value.length; i++){
		if (this.has(value[i])){
			return true;
		}
	}
	return false;
}

var allservices = ["DNS","SNPgraphs","NTP","web","Proxy", "iperf", "radio", "Streaming", "IM", "irc", "games", "wol"];

if (GBrowserIsCompatible()) { 

      var map = new GMap2(document.getElementById("map"));
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());

      // ==== It is necessary to make a setCenter call of some description before adding markers ====
      // ==== At this point we dont know the real values ====
      map.setCenter(new GLatLng(0,0),0);
    
   
      var side_bar_html = "";
      var gmarkers = [];
	  var gicons = [];

      var htmls = [];
      var i = 0;
	  
	  var baseIcon = new GIcon(G_DEFAULT_ICON);
      baseIcon.iconAnchor = new GPoint(9,34);
      baseIcon.iconSize = new GSize(20,34);
      baseIcon.infoWindowAnchor = new GPoint(9,2);


      gicons["Working"] = new GIcon(baseIcon, server + imgpath + "colour086.png");
      gicons["Building"] = new GIcon(baseIcon, server + imgpath + "colour108.png");
      gicons["Planned"] = new GIcon(baseIcon, server + imgpath + "colour125.png");



      // A function to create the marker and set up the event window
      function createMarker(point,name,html,tags,licons) {
        var marker = new GMarker(point,gicons[tags[0]]);
        // === Store the category and name info as a marker properties ===
        marker.mytags = tags;                                 
        marker.myname = name;
		marker.mylicons = licons;
        GEvent.addListener(marker, "click", function() {
          marker.openInfoWindowHtml(html);
        });
        gmarkers.push(marker);
        return marker;
      }

	  // == shows all markers of a particular category, and ensures the checkbox is checked ==
      function show(tag) {
        for (var i=0; i<gmarkers.length; i++) {
          if (gmarkers[i].mytags.has(tag)) {
            gmarkers[i].show();
          }
        }
        // == check the checkbox ==
        document.getElementById(tag+"box").checked = true;
      }

      // == hides all markers of a particular category, and ensures the checkbox is cleared ==
      function hide(tag) {
		for (var i=0; i<gmarkers.length; i++) {
          if (gmarkers[i].mytags.has(tag)) {
            gmarkers[i].hide();
          }
        }
		
		refreshTags();
        // == clear the checkbox ==
        document.getElementById(tag+"box").checked = false;
        // == close the info window, in case its open on a marker that we just hid
        map.closeInfoWindow();
      }
	  
	  function refreshTags(){
		var lservices = [];
		for (var i=0; i<allservices.length; i++){
			if(document.getElementById(allservices[i]+"box").checked){
				lservices.push(allservices[i]);
			}
		}
        for (var i=0; i<gmarkers.length; i++) {
          if (gmarkers[i].mytags.hasone(lservices)) {
            gmarkers[i].show();
          }
        }
	  }

      // == a checkbox has been clicked ==
      function boxclick(box,category) {
        if (box.checked) {
          show(category);
        } else {
          hide(category);
        }
        // == rebuild the side bar
        makeSidebar();
      }

      function myclick(i) {
        GEvent.trigger(gmarkers[i],"click");
      }


      // == rebuilds the sidebar to match the markers currently displayed ==
      function makeSidebar() {
        var html = "";
        for (var i=0; i<gmarkers.length; i++) {
          if (!gmarkers[i].isHidden()) {
			html += '<div class="maplabel">'
            html += '<a href="#guifi" onclick="myclick(' + i + ')">' + gmarkers[i].myname + '<\/a><br>';
			html += ''+gmarkers[i].mylicons;
			html += '</div>';
          }
        }
        document.getElementById("side_bar").innerHTML = html;
      }

	  var distance_on = 0;
	  var distance_off = 0;

      function addistance(lat1, lon1, lat2, lon2, status){
		  	var R = 6371; // km
			var dLat = toRad(lat2-lat1);
			var dLon = toRad(lon2-lon1); 
			var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
					Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
					Math.sin(dLon/2) * Math.sin(dLon/2); 
			var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
			var d = R * c;
			if (status==1){
				distance_on += d;
			}else{
				distance_off += d;
			}
			
	  }
	  
	  function toRad(d) {
		var pi = Math.PI;
		var de_ra = ((d)*(pi/180));
		return de_ra;
	  }
	  
	  function dround(d){
		  return ((Math.round(d*1000)/1000) + '').replace(".", ",");
	  }

      
      // ===== Start with an empty GLatLngBounds object =====     
      var bounds = new GLatLngBounds();
      
          
          for (var k = 0; k < nodes.length; k++) {
            // obtain the attribues of each marker
            var lat = parseFloat(nodes[k][0]);
            var lng = parseFloat(nodes[k][1]);
            var point = new GLatLng(lat,lng);
            var html = nodes[k][2];
            var label = nodes[k][3];
			var tags = nodes[k][4];
			var licons = nodes[k][5];
            // create the marker
            var marker = createMarker(point,label,html,tags,licons);
            map.addOverlay(marker);
            
            // ==== Each time a point is found, extent the bounds ato include it =====
            bounds.extend(point);
			//alert(nodes[k][3])
          }

          //document.getElementById("side_bar").innerHTML = side_bar_html;
          
          // ===== determine the zoom level from the bounds =====
          map.setZoom(map.getBoundsZoomLevel(bounds));

          // ===== determine the centre from the bounds ======
          map.setCenter(bounds.getCenter());

          show("Working");
		  show("Testing");
		  show("Building");
		  hide("Planned");
		  
		  // ========= Now process the polylines ===========
          // read each line
          for (var a = 0; a < lines.length; a++) {
            // get any line attributes
            var colour = "#FF0000";//lines[a].getAttribute("colour");
            var width  = 1; //parseFloat(lines[a].getAttribute("width"));
            // read each point on that line
            var points = lines[a];
            var pts = [];
            for (var p = 0; p < points.length; p++) {
               pts[p] = new GLatLng(parseFloat(points[p]["lat"]),
                                   parseFloat(points[p]["lng"]));
			   colour = points[p]["color"];
			   if (p>0){
				   addistance(parseFloat(points[p-1]["lat"]), parseFloat(points[p-1]["lng"]), parseFloat(points[p]["lat"]), parseFloat(points[p]["lng"]), points[p]["status"] )
			   }
            }
            map.addOverlay(new GPolyline(pts,colour,width));
          }

		  //links are pinted twice
		  document.getElementById("distances").innerHTML = dround(distance_on/2) + " qm. actius\nde " + dround(distance_on/2 + distance_off/2) + " qm.";
		  // == create the initial sidebar ==
		  makeSidebar();

        

    }
    
    // display a warning if the browser was not compatible
    else {
      alert("Sorry, the Google Maps API is not compatible with this browser");
    }
	
	