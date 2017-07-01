module.exports =

  tableName: 'tag'

  autoPK: false

  schema: true

  attributes:

    name:
      type: 'string'
      primaryKey: true
      required: true

    hotspot:
      collection: 'hotspot'
      via: 'tag'
