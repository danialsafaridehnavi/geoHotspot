env = require './env.coffee'
geolib = require 'geolib'
	
MenuCtrl = ($scope) ->
	$scope.env = env
	$scope.navigator = navigator

HotspotCtrl = ($scope, model, $location) ->
	if _.isUndefined model.location
		_.extend model, 
			location:
				coordinates: []
	
	_.extend $scope,
		model: model
		tags: model.tags || []		
		edit: (id) ->
			$location.url "/hotspot/edit/#{id}"
		save: ->
			hotspot = $scope.model
			hotspot.newTag = $scope.tags
			if hotspot.id
				hotspot.newTag = _.where hotspot.tags, {id: 0}
				hotspot.tags = _.filter hotspot.tags, (tag) ->
					tag.id != 0				
				hotspot.delTag = _.difference hotspot.origTagID, (_.map hotspot.newTag, (tag) ->	tag.id)										
			hotspot.$save().then =>
				$location.url "/hotspot"		
		

HotspotListCtrl = ($scope, collection, $location, model, uiGmapGoogleMapApi) ->
	_.extend $scope,
		collection: collection
		create: ->
			$location.url "/hotspot/create"			
		read: (id) ->
			$location.url "/hotspot/read/#{id}"						
		edit: (id) ->
			$location.url "/hotspot/edit/#{id}"			
		delete: (obj) ->
			collection.remove obj
			removetags = obj.tags
			_.each removetags, (tag) ->
				tagModel = new model.Tag id: tag.id
				tagModel.$fetch()
					.then ->
						if (tagModel.hotspots).length == 1
							tagModel.$destroy()											
		loadMore: ->
			collection.$fetch({params: {sort: 'name ASC'}})
				.then ->
					$scope.$broadcast('scroll.infiniteScrollComplete')
				.catch alert
			return @

newSearch = (maps, collection) ->
	newCenter = 
		latitude:	maps.getCenter().lat()
		longitude:	maps.getCenter().lng()
	bounds =
		latitude:	maps.getBounds().getNorthEast().lat()
		longitude:	maps.getBounds().getNorthEast().lng()
					
	distance = geolib.getDistance(newCenter, bounds)
	collection.$fetch({params: {longitude: newCenter.longitude, latitude: newCenter.latitude, distance: distance/1000 }})
					
geoCtrl = ($scope, collection, coords, model, uiGmapGoogleMapApi) ->
	convert = (collection) ->
		_.map collection, (item) ->
			id:		item._id
			latitude:	parseFloat(item.location.coordinates[1])
			longitude:	parseFloat(item.location.coordinates[0])

	_.extend $scope,
		collection: collection
		map:
			center:	coords
			zoom:	env.map.zoom
			bounds:	{}
			control: {}
			events:
				zoom_changed: (maps) ->
					newSearch(maps, collection)
				center_changed: (maps) ->
					newSearch(maps, collection)
		options:
			scrollwheel:	false
			draggable:		true
		marker:
			id: 0
			coords:
				latitude:	coords.latitude
				longitude:	coords.longitude			
			options:
				icon:			'img/hotspot/blue_marker.png'
				labelAnchor:	"#{env.map.labelAnchor}"
				labelClass:		"marker-labels"
				labelContent:	"lat: #{coords.latitude} lon: #{coords.longitude}"
				
		markers:	convert(collection.models)

	$scope.$watchCollection 'collection', ->
		$scope.markers = convert($scope.collection.models)


HotspotFilter = ->
	(hotspots, search) ->
		r = new RegExp(search, 'i')

		if search
			return _.filter hotspots, (item) ->
				r.test(item?.name) or r.test(item?.longitude) or r.test(item?.latitude)
		else
			return hotspots				

config = ->
	return
	
angular.module('starter.controller', ['ionic', 'ngCordova', 'http-auth-interceptor', 'starter.model', 'platform']).config [config]	
angular.module('starter.controller').controller 'MenuCtrl', ['$scope', MenuCtrl]
angular.module('starter.controller').controller 'HotspotCtrl', ['$scope', 'model', '$location', '$stateParams', HotspotCtrl]
angular.module('starter.controller').controller 'HotspotListCtrl', ['$scope', 'collection', '$location', 'model', HotspotListCtrl]
angular.module('starter.controller').controller 'geoCtrl', ['$scope', 'collection', 'coords', 'model', geoCtrl]
angular.module('starter.controller').filter 'hotspotFilter', HotspotFilter