# based on http://sequelizejs.com/heroku

unless global.hasOwnProperty 'db'
  Sequelize = require 'sequelize'
  match = process.env.HEROKU_POSTGRESQL_SILVER_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)
  sequelize = new Sequelize match[5], match[1], match[2],
    dialect:  'postgres'
    protocol: 'postgres'
    port:     match[4]
    host:     match[3]
    logging:  true
  global.db = {Sequelize, sequelize, Donation: sequelize.import __dirname + '/donation'}

module.exports = global.db
    
  