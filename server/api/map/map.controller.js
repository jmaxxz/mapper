/**
 * Using Rails-like standard naming convention for endpoints.
 * POST    /maps              ->  create
 * GET     /map/:id           ->  show
 */

'use strict';

var _ = require('lodash');
var geojsonhint = require('geojsonhint');
var crypto = require('crypto');
var azure = require('azure-storage');
var blobService = azure.createBlobService();
var container = 'maps';

blobService.createContainerIfNotExists(container, {}, function(error, result, response){
    if(!error){
        console.log("Could not create blob container");
    }
});

exports.show = function(req, res) {
  blobService.getBlobProperties(container, req.params.id, function (error, blobInfo) {
    if(error) {
      res.status(404).json({excuse:'Map not found'});
    } else {
      res.header('content-type', 'application/json');
      blobService.getBlobToStream(container, req.params.id, res, function () { });
    }
  });
};

// Get list of things
exports.create = function(req, res) {
  var map = JSON.stringify(req.body);
  var hint = geojsonhint.hint(map);
  if(hint.length == 0){
    var shasum = crypto.createHash('sha1');
    shasum.update(map, 'utf8');
    var mapDiget = shasum.digest('base64');
    blobService.createBlockBlobFromText(container, mapDiget, map, function(error){
      if(error){
        console.log(error);
        res.status(500).json({excuse:'azure blew up in the webserver\'s face'});
      } else {
        res.json({id:mapDiget});
      }
    });
  } else {
    res.status(400).json({excuse:'Map did not appear to be valid geojson.', hints:hint });
  }
};