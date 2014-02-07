// JavaScript Document
var map = null;
var setstartpermission = false;
var startmarker = null;
function initialize() {
	var latlng = new google.maps.LatLng(25.021373,121.534066);
	var myOptions = {
		zoom: 14,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);
	
	google.maps.event.addListener(map, 'click', function(event) {placeMarker(event.latLng,map); });
	 
} 

function pad(number, length) {
   
    var str = '' + number;
    while (str.length < length) {
        str = '0' + str;
    }
    return str;
}

function placeMarker(latLngValue,map){
	if(startmarker!=null && setstartpermission==true)startmarker.setMap(null);
	if(setstartpermission){		
		startmarker = new google.maps.Marker({
											position: latLngValue,
											map:map,
											draggable: true 
											});
		var iconFileG = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'; 
		startmarker.setIcon(iconFileG) ;

	}
}

function cleansetstart(){
	if(startmarker!=null){
		startmarker.setMap(null);
		startmarker=null;
	}
}


var locationt =null;
var markersArray = []; 
function showmarker(name) {
	clearOverlays();

	if (name == 'testmarker') {
			
		var myLatlng = new google.maps.LatLng(25.021373,121.534066);
		var marker = new google.maps.Marker({
			position: myLatlng,
			title:"Hello World!"
		});
		
		
		var contentString = '~~Hello World~~';
		var infowindow = new google.maps.InfoWindow({content: contentString });
		google.maps.event.addListener(marker, 'click', function() {   infowindow.open(map,marker); });
		
		
		// To add the marker to the map, call setMap();
		marker.setMap(map);  
	}
	document.write("Hello World");


}

function showmarkerByName(name) {
	clearOverlays();
	for (var x in restaurant)
	{
		if ( restaurant[x]['name'] == name){
			/*var geocoder = new google.maps.Geocoder();  //定義一個Geocoder物件
			var results = null;
			geocoder.geocode({ address: restaurant[x]['address'] },    //設定地址的字串
					function(results, status) {    //callback function
							if (status == google.maps.GeocoderStatus.OK) {    //判斷狀態
								locationt = results[0].geometry.location;    
								var myLatlng = locationt;
								var marker = new google.maps.Marker({
									position: myLatlng,
									title:restaurant[x]['name']
								});
							
								var contentString = restaurant[x]['comment']+'<br/>'+'<br/>'+'-Tag: ';
								for(var kindi=0 ;kindi<restaurant[x]['kind'].length; kindi++)contentString=contentString+restaurant[x]['kind'][kindi]+'.';
								contentString=contentString+'<br/>'+'-Price: ';
								for(var pricei=0 ;pricei<restaurant[x]['price'].length; pricei++)contentString=contentString+restaurant[x]['price'][pricei]+'.';
								var infowindow = new google.maps.InfoWindow({content: contentString });
								google.maps.event.addListener(marker, 'click', function() {   infowindow.open(map,marker); });
								
								marker.setMap(map); 
							} else {
								alert('Error');
							}
					}
			);*///使用失敗的geocoder(大量資料失敗)
			var myLatlng = new google.maps.LatLng(restaurant[x]['position'][1],restaurant[x]['position'][0]);
			var marker = new google.maps.Marker({
				position: myLatlng,
				title:restaurant[x]['name']
			});
			markersArray.push(marker);
			var contentString = restaurant[x]['comment']+'<br/>'+'<br/>'+'-Tag: ';
			for(var kindi=0 ;kindi<restaurant[x]['kind'].length; kindi++)contentString=contentString+restaurant[x]['kind'][kindi]+'.';
			contentString=contentString+'<br/>'+'-Price: ';
			for(var pricei=0 ;pricei<restaurant[x]['price'].length; pricei++)contentString=contentString+restaurant[x]['price'][pricei]+'.';
			attachSecretMessage(marker,contentString);
			marker.setMap(map);

		}
	}

}

function showmarkerBykind(kindname) {
	clearOverlays();
	for (var x=0;x<restaurant.length;x++)
	{
		if (containKind(restaurant[x]['kind'],kindname)){
			var myLatlng = new google.maps.LatLng(restaurant[x]['position'][1],restaurant[x]['position'][0]);
			var marker = new google.maps.Marker({
				position: myLatlng,
				title:restaurant[x]['name']
			});
			markersArray.push(marker);
			var contentString = restaurant[x]['name']+'<br/>'+'<br/>'+restaurant[x]['comment']+'<br/>'+'<br/>'+'-Tag: ';
			for(var kindi=0 ;kindi<restaurant[x]['kind'].length; kindi++)contentString=contentString+restaurant[x]['kind'][kindi]+'.';
			contentString=contentString+'<br/>'+'-Price: ';
			for(var pricei=0 ;pricei<restaurant[x]['price'].length; pricei++)contentString=contentString+restaurant[x]['price'][pricei]+'.';
			
			attachSecretMessage(marker,contentString);
			/*var infowindow = new google.maps.InfoWindow();
			
			infowindow.setContent(contentString);    //InfoWindow的內容，可用Html語法
			infowindow.setPosition(myLatlng);    //座標
			google.maps.event.addListener(marker, 'click', function() {   infowindow.open(map,marker); });*/
			
			marker.setMap(map);
		}
	}

}


function containKind(restaurant_kind,kindname){
	if(kindname == null || kindname.length == 0 || restaurant_kind==null)return true;
	for(var y in kindname){
		for(var x in restaurant_kind){
			if(restaurant_kind[x] == kindname[y]) return true;
		}
	}
	return false;
}

function okprice(pricearray,price_min,price_max){
	if(pricearray == null || (price_min==null && price_max==null))return true;
	if(price_min==null)price_min=0;
	if(price_max==null)price_max=99999;
	for(var x in pricearray)if(pricearray[x]<=price_max && pricearray[x]>=price_min)return true;
	return false;
}

function containName(restaurant_name,strname){
	if(strname == null || restaurant_name==null)return true;
	if(restaurant_name.search(strname)>-1)return true;
	return false;
}

function okdistance(LatLngt,nowposition,distance){
	if(LatLngt == null || nowposition == null || distance == null)return true;
	var distancet=google.maps.geometry.spherical.computeDistanceBetween (new google.maps.LatLng(LatLngt[1], LatLngt[0]), nowposition);

	
	if(distance>=distancet)return true;
	return false;
}

function containTiming(timingarray,timing){
	if(timingarray == null || timing == null)return true;
	for(var x in timingarray)if(timingarray[x] == timing)return true;
	return false;
}

function okrank(realstar,stars_min){
	if(realstar == null || stars_min == null)return true;
	if(realstar>=stars_min)return true;
	return false;
}

function showmarkerByAny(restaurantname,price_min,price_max,kindname,distance,nowposition,timing,stars_min) {
	clearOverlays();
	if(restaurantname == '' && price_min == null && price_max == null && kindname == null && distance == null && nowposition == null && timing == null && stars_min == null)return true;
	for (var x=0;x<restaurant.length;x++)
	{
		if (containName(restaurant[x]['name'],restaurantname) && containKind(restaurant[x]['kind'],kindname) && okprice(restaurant[x]['price'],price_min,price_max) && okdistance(restaurant[x]['position'],nowposition,distance) && containTiming(restaurant[x]['occasion'],timing) && okrank(restaurant[x]['star'],stars_min)){
			var myLatlng = new google.maps.LatLng(restaurant[x]['position'][1],restaurant[x]['position'][0]);
			var marker = new google.maps.Marker({
				position: myLatlng,
				title:restaurant[x]['name']
			});
			markersArray.push(marker);
			var contentString = "<a href=\"http://www.google.com.tw/search?hl=zh-TW&rlz=1T4GGHP_zh-TWTW447TW448&biw=1382&bih=638&q="+restaurant[x]['name']+"\" target=\"_new\">"+'<b>'+restaurant[x]['name']+'</b>'+"</a>"+'<br/>'+'<br/>'+restaurant[x]['address']+'<br/>'+'<br/>'+'-Tag: ';
			if(restaurant[x]['kind']!=null)for(var kindi=0 ;kindi<restaurant[x]['kind'].length; kindi++)contentString=contentString+restaurant[x]['kind'][kindi]+'.';
			contentString=contentString+'<br/>'+'-Price: ';
			if(restaurant[x]['price']!=null)for(var pricei=0 ;pricei<restaurant[x]['price'].length; pricei++)contentString=contentString+restaurant[x]['price'][pricei]+'.';
			
			var showid = restaurant[x]['id'];
			//showid = pad(showid,6);
			contentString=contentString +'<br/>'+ "<a href=\"http://www.combinat.vacau.com/feedback.php?id="+showid+"\" target=\"_blank\" width=480 height=480><img src=\"PIC/moremore.png\"/></a>";
			
			

			attachSecretMessage(marker,contentString);
			/*var infowindow = new google.maps.InfoWindow();
			
			infowindow.setContent(contentString);    //InfoWindow的內容，可用Html語法
			infowindow.setPosition(myLatlng);    //座標
			google.maps.event.addListener(marker, 'click', function() {   infowindow.open(map,marker); });*/
			
			marker.setMap(map);
		}
	}

}

function attachSecretMessage(marker, content) {
       
        var infowindow = new google.maps.InfoWindow({
          content: content
        });
 
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map, marker);
        });
      }




function getLatLngByAddr(add) {
    var geocoder = new google.maps.Geocoder();  //定義一個Geocoder物件
	var results = null;
    geocoder.geocode({ address: add },    //設定地址的字串
        	function(results, status) {    //callback function
            		if (status == google.maps.GeocoderStatus.OK) {    //判斷狀態
                		locationt = results[0].geometry.location;    // location.Pa 緯度      // location.Qa 經度   
            		} else {
               			alert('Error');
            		}
      		}
 	);
}

function clearOverlays() {
	if (markersArray) {
		for (i in markersArray) {
			markersArray[i].setMap(null);
		}
	}
}





function setstartchange(){
	setstartpermission = !setstartpermission;
	
}
