## FarmManager

**Description**

> Handles everything farms

**Parent**

> [AbstractManager](?version=script&category=32&class=407)

**Functions**

- [consoleCommandSetFarm](#consolecommandsetfarm)
- [createFarm](#createfarm)
- [delete](#delete)
- [destroyFarm](#destroyfarm)
- [getFarmById](#getfarmbyid)
- [getFarmByUserId](#getfarmbyuserid)
- [getFarmForUniqueUserId](#getfarmforuniqueuserid)
- [getFarms](#getfarms)
- [getSleepCamera](#getsleepcamera)
- [getSpawnPoint](#getspawnpoint)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadMapData](#loadmapdata)
- [mergeFarmlandsForSingleplayer](#mergefarmlandsforsingleplayer)
- [mergeFarmsForSingleplayer](#mergefarmsforsingleplayer)
- [mergeObjectsForSingleplayer](#mergeobjectsforsingleplayer)
- [new](#new)
- [playerJoinedGame](#playerjoinedgame)
- [playerQuitGame](#playerquitgame)
- [removeFarm](#removefarm)
- [removeUserFromFarm](#removeuserfromfarm)
- [saveToXMLFile](#savetoxmlfile)
- [transferMoney](#transfermoney)
- [unloadMapData](#unloadmapdata)
- [update](#update)
- [updateFarms](#updatefarms)

### consoleCommandSetFarm

**Description**

> Commands

**Definition**

> consoleCommandSetFarm()

**Arguments**

| any | farmId |
|-----|--------|

### createFarm

**Description**

> Create a farm

**Definition**

> createFarm()

**Arguments**

| any | name     |
|-----|----------|
| any | color    |
| any | password |
| any | farmId   |

### delete

**Description**

> Deletes field mission manager

**Definition**

> delete()

### destroyFarm

**Description**

> Destroy given farm

**Definition**

> destroyFarm()

**Arguments**

| any | farmId |
|-----|--------|

### getFarmById

**Description**

> Get the farm object by given farmId

**Definition**

> getFarmById()

**Arguments**

| any | farmId |
|-----|--------|

### getFarmByUserId

**Description**

> Get farm for given userId. To be used when player is in the game.

**Definition**

> getFarmByUserId()

**Arguments**

| any | userId |
|-----|--------|

### getFarmForUniqueUserId

**Description**

> Get farm for given userId. To be used when player is not in the game

**Definition**

> getFarmForUniqueUserId()

**Arguments**

| any | uniqueUserId |
|-----|--------------|

### getFarms

**Description**

> Get the array of known farms.
> Callers should not modify this array.

**Definition**

> getFarms()

### getSleepCamera

**Description**

> Get the sleep camera for given farm

**Definition**

> getSleepCamera()

**Arguments**

| any | farmId |
|-----|--------|

### getSpawnPoint

**Description**

> Get the spawn point for given farm

**Definition**

> getSpawnPoint()

**Arguments**

| any | farmId |
|-----|--------|

### loadFromXMLFile

**Description**

> Load fieldjob data from xml savegame file

**Definition**

> loadFromXMLFile(string filename)

**Arguments**

| string | filename | xml filename |
|--------|----------|--------------|

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile |
|-----|---------|

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

### mergeFarmlandsForSingleplayer

**Description**

> Second step of merging: transfer all lands to the singleplayer farm

**Definition**

> mergeFarmlandsForSingleplayer()

### mergeFarmsForSingleplayer

**Description**

> Merge all farms into a single farm when opening an MP game in singleplayer

**Definition**

> mergeFarmsForSingleplayer()

### mergeObjectsForSingleplayer

**Description**

> Third step of merging: move vehicles and bales to singleplayer farm

**Definition**

> mergeObjectsForSingleplayer()

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

### playerJoinedGame

**Description**

> A new player joined the game. Handle their farm.

**Definition**

> playerJoinedGame()

**Arguments**

| any | uniqueUserId |
|-----|--------------|
| any | userId       |
| any | user         |
| any | connection   |

### playerQuitGame

**Description**

> A player quit the game, update the farms

**Definition**

> playerQuitGame()

**Arguments**

| any | userId |
|-----|--------|

### removeFarm

**Description**

> Farm has been destroyed. Remove from lists

**Definition**

> removeFarm()

**Arguments**

| any | farmId |
|-----|--------|

### removeUserFromFarm

**Description**

> Remove player from their farm. Only works if the caller has permission (master user, farm manager)

**Definition**

> removeUserFromFarm()

**Arguments**

| any | userId |
|-----|--------|

### saveToXMLFile

**Description**

> Write field mission data to savegame file

**Definition**

> saveToXMLFile(string xmlFilename)

**Arguments**

| string | xmlFilename | file path |
|--------|-------------|-----------|

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

### transferMoney

**Description**

> Transfer an amount of money from the current user's farm to a destination farm.
> Triggers a network event which checks farm balances and applies the change. Successful execution requires the current
> user to have permission to transfer money as well as their current farm to have a sufficient balance.

**Definition**

> transferMoney()

**Arguments**

| any | destinationFarm |
|-----|-----------------|
| any | amount          |

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

### update

**Description**

> Updates field mission ownership data from xml savegame file

**Definition**

> update(string filename)

**Arguments**

| string | filename | xml filename |
|--------|----------|--------------|

### updateFarms

**Description**

> On client, update the list of farms and set farm for given farmId

**Definition**

> updateFarms()

**Arguments**

| any | farms        |
|-----|--------------|
| any | playerFarmId |