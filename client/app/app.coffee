'use strict'

L.Icon.Default.imagePath = '/bower_components/leaflet/dist/images';
map = L.map('map').setView([0, 0], 2)

L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
	attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map)

sidebar = L.control.sidebar('sidebar', {
	position: 'left'
})
map.addControl(sidebar)
L.easyButton('fa-upload', (()-> sidebar.toggle()), 'upload', map)

renderMap = (geojson)-> L.geoJson(geojson).addTo(map)

#crossroads config
crossroads.addRoute('/{id}', (id)->
	$.getJSON('/api/maps/'+encodeURI(id), renderMap)
)

crossroads.bypassed.add((request) ->
	console.log(request);
)

crossroads.parse(window.location.pathname)

#file uploader
onSuccessfullUpload = (data)->
	window.location='/'+encodeURIComponent(data.id)
	return true

uploadMap = (file) ->
	$.ajax(
			type: 'POST', 
			url: '/api/maps', 
			data: file,
			contentType: 'application/json; charset=utf-8',
			success: onSuccessfullUpload,
		)

handleFileSelect = ((evt) -> 
	files = this.files;
	output = [];
	if(files.length > 0)
		reader = new FileReader()
		reader.onload = (e)-> uploadMap(e.target.result)
		reader.readAsText(files[0])
);

$('[name="geojson"]').on('change', handleFileSelect);
