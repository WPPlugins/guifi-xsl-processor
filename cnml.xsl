<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="gmapikey" select="'You have to override this parameter'"/>
  <xsl:param name="mapwidth" select="'400px'"/>
  <xsl:param name="mapheight" select="'450px'"/>
  <xsl:param name="server"/>
  <xsl:param name="jspath">/wp-content/plugins/guifi-xsl-processor/</xsl:param>
  <xsl:param name="imgpath">/wp-content/plugins/guifi-xsl-processor/</xsl:param>
  <xsl:param name="debug" select="'false'"/>
  <xsl:param name="showtree" select="'off'"/>
  <xsl:param name="supernodes" select="'false'"/>
  
  <xsl:template match="data">
  <xsl:text disable-output-escaping="yes">&lt;script type="text/javascript" src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=true&amp;key=</xsl:text>
  <xsl:value-of select="$gmapikey"/>
  <xsl:text disable-output-escaping="yes">"&gt;&lt;/script&gt;</xsl:text>
    <div id="guifi">
		<form>
      Per estat:<br></br>
		  <input type="checkbox" id="Workingbox" onclick="boxclick(this,'Working')" /> 
		  <label for="Workingbox"> Actius</label>
		  <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
		  <input type="checkbox" id="Testingbox" onclick="boxclick(this,'Testing')" />
		  <label for="Testingbox"> En proves</label>
		  <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
		  <input type="checkbox" id="Buildingbox" onclick="boxclick(this,'Building')" />
		  <label for="Buildingbox"> En construccio</label>
		  <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
		  <input type="checkbox" id="Plannedbox" onclick="boxclick(this,'Planned')" />
		  <label for="Plannedbox"> Projectats</label>
		  <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
		  <input type="checkbox" id="Reservedbox" onclick="boxclick(this,'Reserved')" />
		  <label for="Reservedbox"> Reservats</label>
		  <br />
      Per serveis:<br></br>
	  <div class="srvfilter">
      <input type="checkbox" id="DNSbox" onclick="boxclick(this,'DNS')" />
	  <label for="DNSbox"> DNS</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="SNPgraphsbox" onclick="boxclick(this,'SNPgraphs')" />
      <label for="SNPgraphsbox"> SNPgraphs</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="NTPbox" onclick="boxclick(this,'NTP')" />
      <label for="NTPbox"> NTP</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="webbox" onclick="boxclick(this,'web')" />
      <label for="webbox"> web</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="iperfbox" onclick="boxclick(this,'iperf')" />
      <label for="iperfbox"> Iperf</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="Proxybox" onclick="boxclick(this,'Proxy')" />
      <label for="Proxybox"> Proxy</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
	  </div>
	  <div class="srvfilter">
      <input type="checkbox" id="radiobox" onclick="boxclick(this,'radio')" />
      <label for="radiobox"> radio</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="gamesbox" onclick="boxclick(this,'games')" />
      <label for="gamesbox"> Jocs</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="wolbox" onclick="boxclick(this,'wol')" />
      <label for="wolbox"> ON remot</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="Streamingbox" onclick="boxclick(this,'Streaming')" />
      <label for="Streamingbox"> Streaming</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="IMbox" onclick="boxclick(this,'IM')" />
      <label for="IMbox"> IM</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
	  <div class="srvfilter">
      <input type="checkbox" id="ircbox" onclick="boxclick(this,'irc')" />
      <label for="ircbox"> IRC</label>
      <xsl:text disable-output-escaping="yes">&amp;nbsp; &amp;nbsp;</xsl:text>
      </div>
    </form>  
		<table border="0">
		  <tr>
			<td>
			   <div id="map">
           <xsl:attribute name="style">width:<xsl:value-of select="$mapwidth"/>;height:<xsl:value-of select="$mapheight"/>;</xsl:attribute>
			   </div>
			</td>
		  </tr>
		  <tr>
		  	<td>
				<div id="distances"></div>
			</td>
		  </tr>
		  <tr>
			<td valign="top" style="">
			   <div id="side_bar"></div>
			</td>
		  </tr>
		</table>
      <xsl:for-each select="cnml/network/zone">
        <xsl:call-template name="zone">
          <xsl:with-param name="parent">
            <xsl:value-of select="@title"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
		
	</div>
    
  <script type="text/javascript">
  var server = "<xsl:value-of select="$server"/>";
  var imgpath = "<xsl:value-of select="$imgpath"/>";
  var nodes = new Array();
  var i = 0;
  <xsl:for-each select="cnml/network/zone">
    <xsl:call-template name="gnode"></xsl:call-template>
  </xsl:for-each>

  var lines = new Array();
  var li = 0;
  <xsl:for-each select="cnml/network/zone">
    <xsl:call-template name="links"></xsl:call-template>
  </xsl:for-each>

  </script>
  <xsl:text disable-output-escaping="yes">&lt;script type="text/javascript" src="</xsl:text><xsl:value-of select="$server"/>
    <xsl:value-of select="$jspath"/><xsl:text disable-output-escaping="yes">cnml.js"&gt;&lt;/script&gt;</xsl:text>

    
  </xsl:template>
  
  <!-- zona o subzona -->
  <xsl:template name="zone">
    <xsl:param name="parent"></xsl:param>
  	<xsl:if test="$showtree='on'">
	<h3>Zona <xsl:value-of select="$parent"/></h3>
	<ul>
	<xsl:for-each select="node">
		<xsl:sort select="@status" order="descending"/>
		<li>
			<xsl:call-template name="status"><xsl:with-param name="mainclass">node</xsl:with-param><xsl:with-param name="show">false</xsl:with-param></xsl:call-template>
			<xsl:value-of select="@title"/>
			<span>
				<xsl:call-template name="status"><xsl:with-param name="mainclass">status</xsl:with-param></xsl:call-template>
			</span>
			<xsl:if test="device">
				<ul>
				<li><b>Dispositius</b></li>
				<xsl:for-each select="device">
					<xsl:sort select="@status" order="descending"/>
					<xsl:sort case-order="upper-first" data-type="text" select="@status"/>
					<li>
						<xsl:call-template name="status"><xsl:with-param name="mainclass">device</xsl:with-param><xsl:with-param name="show">false</xsl:with-param></xsl:call-template>
						<xsl:value-of select="@title"/>
						<span>
							<xsl:call-template name="status"><xsl:with-param name="mainclass">status</xsl:with-param></xsl:call-template>
						</span>
					</li>
				</xsl:for-each>
				</ul>
			</xsl:if>
		</li>
    
	</xsl:for-each>
	<xsl:for-each select="zone">
      <xsl:call-template name="zone">
        <xsl:with-param name="parent">
          <xsl:value-of select="$parent"/> - <xsl:value-of select="@title"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
	</ul>
	</xsl:if>  	
  </xsl:template>
  
  <!-- nodes grafics -->
  <xsl:template name="gnode">
    <xsl:for-each select="node">
      <xsl:if test="$supernodes='true' and @links>1 or $supernodes='false'">
	      var lat = parseFloat(<xsl:value-of select="@lat"/>);
	      var lng = parseFloat(<xsl:value-of select="@lon"/>);
	      var html = "<xsl:value-of select="@title"/><br></br><xsl:call-template name="detailnode"></xsl:call-template>";
	      var label = "<xsl:value-of select="@title"/>";
	      var licons = "";//"<xsl:call-template name="maplabelvalues"></xsl:call-template>";
	      //label = label + "<br></br>" + licons;
	      var tags = new Array("<xsl:value-of select="@status"/>"<xsl:call-template name="servicetags"></xsl:call-template>);
	      nodes[i] = new Array(lat, lng, html, label, tags, licons);
	      i++;
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="zone">
      <xsl:call-template name="gnode"></xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!-- detall node -->
  <xsl:template name="detailnode">
  	<xsl:if test="@access_points"><b><xsl:text disable-output-escaping="yes">punts d&amp;#8217;acc&amp;egrave;s</xsl:text>:</b> <xsl:value-of select="@access_points"/><br></br></xsl:if>
	<xsl:if test="@devices"><b>dispositius:</b><xsl:value-of select="@devices"/><br></br></xsl:if>
	<xsl:if test="@links"><b><xsl:text disable-output-escaping="yes">enlla&amp;ccedil;os</xsl:text>:</b> <xsl:value-of select="@links"/><br></br></xsl:if>
    <xsl:if test="@services"><b>serveis:</b><xsl:value-of select="@services"/><xsl:call-template name="maplabelvalues"></xsl:call-template></xsl:if>
  </xsl:template>
  
  <!-- status -->
  <xsl:template name="status">
  	<xsl:param name="mainclass">status</xsl:param>
	<xsl:param name="show">true</xsl:param>
	<xsl:choose>
		<xsl:when test="@status='Working'">
			<xsl:attribute name="class"><xsl:value-of select="$mainclass"/> active</xsl:attribute>
			<xsl:if test="$show='true'">
			(actiu)				
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="class"><xsl:value-of select="$mainclass"/> unactive</xsl:attribute>
			<xsl:if test="$show='true'">
			(inactiu)				
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  
  <!-- get geo by id to add point for polyline-->
  <xsl:template name="geobyid">
    <xsl:param name="id"></xsl:param>
    <xsl:param name="status"></xsl:param>
    <xsl:for-each select="node">
      <xsl:if test="$id=@id">
        var lat = parseFloat(<xsl:value-of select="@lat"/>);
        var lng = parseFloat(<xsl:value-of select="@lon"/>);
        var color;
		var status;
        <xsl:choose>
          <xsl:when test="$status='Working'">color="#00FF00";status=1;</xsl:when>
          <xsl:otherwise>color="#FF0000";status=0;</xsl:otherwise>
        </xsl:choose>
        pts[nli] = [];
        pts[nli]["lat"] = lat;
        pts[nli]["lng"] = lng;
        pts[nli]["color"] = color;
		pts[nli]["status"] = status;
        nli++;
      </xsl:if>
      
    </xsl:for-each>
    <xsl:for-each select="zone">
      <xsl:call-template name="geobyid">
        <xsl:with-param name="id" select="$id"></xsl:with-param>
        <xsl:with-param name="status" select="$status"></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Polylines -->
  <xsl:template name="links">
      <xsl:for-each select="node">
        <xsl:variable name="nodelat" select="@lat"/>
        <xsl:variable name="nodelon" select="@lon"/>
        
        <xsl:for-each select="device/radio/interface/link">
          var pts = [];
          var lat = parseFloat(<xsl:value-of select="$nodelat"/>);
          var lng = parseFloat(<xsl:value-of select="$nodelon"/>);

          /*node links index*/
          var nli = 0;
          pts[nli] = [];
          pts[nli]["lat"] = lat;
          pts[nli]["lng"] = lng;
          nli++;
          //alert("connectat amb <xsl:value-of select="@linked_node_id"/>");
          <xsl:variable name="linked_node_id" select="@linked_node_id"></xsl:variable>
          <xsl:variable name="link_status" select="@link_status"></xsl:variable>
          
          <xsl:for-each select="/data/cnml/network/zone">
            <xsl:call-template name="geobyid">
              <xsl:with-param name="id" select="$linked_node_id"></xsl:with-param>
              <xsl:with-param name="status" select="$link_status"></xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
          lines[li] = pts;
          li++;
        </xsl:for-each>
        
      </xsl:for-each>
      <xsl:for-each select="zone">
        <xsl:call-template name="links"></xsl:call-template>
      </xsl:for-each>
  </xsl:template>
  
  <!-- service icons -->
  <xsl:template name="maplabelvalues">
  	<xsl:text disable-output-escaping="yes">&lt;div class=services&gt;</xsl:text><xsl:for-each select="device/service">
      <xsl:text disable-output-escaping="yes">&lt;img src='</xsl:text><xsl:value-of select="$server"/><xsl:value-of select="$imgpath"/><xsl:text disable-output-escaping="yes">service_</xsl:text><xsl:value-of select="@type"/><xsl:if test="@status='Working'">_Working</xsl:if><xsl:text  disable-output-escaping="yes">.png' alt='</xsl:text><xsl:value-of select="@type"/><xsl:text  disable-output-escaping="yes">' title='</xsl:text><xsl:value-of select="@type"/><xsl:text  disable-output-escaping="yes">'/&gt;</xsl:text>
    </xsl:for-each><xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
  </xsl:template>
  
  <!-- service tags -->
  <xsl:template name="servicetags">
    <xsl:for-each select="device/service">
      ,"<xsl:value-of select="@type"/>"
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>


