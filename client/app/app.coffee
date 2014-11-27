'use strict'
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

crossroads.addRoute('/{id}', (id)->
	$.getJSON('/api/maps/'+encodeURI(id), renderMap)
);

crossroads.bypassed.add((request) ->
    console.log(request);
);

crossroads.parse(window.location.pathname)
