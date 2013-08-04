module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Donation',
    name: DataTypes.STRING
    amt: DataTypes.INTEGER
    created_at: DataTypes.DATE