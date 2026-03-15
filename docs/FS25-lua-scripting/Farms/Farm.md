## Farm

**Description**

> Default permissions on a farm for newly added players.

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [addUser](#adduser)
- [calculateDailyLoanInterest](#calculatedailyloaninterest)
- [canBeDestroyed](#canbedestroyed)
- [changeBalance](#changebalance)
- [demoteUser](#demoteuser)
- [farmPropertyChanged](#farmpropertychanged)
- [getActiveUsers](#getactiveusers)
- [getBalance](#getbalance)
- [getColor](#getcolor)
- [getEquity](#getequity)
- [getFarmhouse](#getfarmhouse)
- [getIconSliceId](#geticonsliceid)
- [getIconUVs](#geticonuvs)
- [getId](#getid)
- [getIsContractingFor](#getiscontractingfor)
- [getLoan](#getloan)
- [getNumActivePlayers](#getnumactiveplayers)
- [getNumPlayers](#getnumplayers)
- [getSleepCamera](#getsleepcamera)
- [getSpawnPoint](#getspawnpoint)
- [getUserPermissions](#getuserpermissions)
- [isUserFarmManager](#isuserfarmmanager)
- [loadFromXMLFile](#loadfromxmlfile)
- [merge](#merge)
- [new](#new)
- [onUserJoinGame](#onuserjoingame)
- [onUserQuitGame](#onuserquitgame)
- [promoteUser](#promoteuser)
- [removeUser](#removeuser)
- [resetToSingleplayer](#resettosingleplayer)
- [saveToXMLFile](#savetoxmlfile)
- [setIsContractingFor](#setiscontractingfor)
- [setUserPermission](#setuserpermission)
- [updateMaxLoan](#updatemaxloan)

### addUser

**Description**

> Add a new user to the farm. This adds it to the players and active players list.
> And also gives default permissions.

**Definition**

> addUser()

**Arguments**

| any | userId        |
|-----|---------------|
| any | uniqueUserId  |
| any | isFarmManager |
| any | user          |

### calculateDailyLoanInterest

**Description**

> Calculate the daily loan interest

**Definition**

> calculateDailyLoanInterest()

**Return Values**

| any | daily | loan interest |
|-----|-------|---------------|

### canBeDestroyed

**Description**

> Get whether the farm can be destroyed (must not have any active users)

**Definition**

> canBeDestroyed()

### changeBalance

**Description**

> Add or remove money from the farm

**Definition**

> changeBalance(float amount, table? moneyType)

**Arguments**

| float  | amount    | Amount to add (positive) or remove (negative) |
|--------|-----------|-----------------------------------------------|
| table? | moneyType |                                               |

### demoteUser

**Description**

> Demote a user from farm manager.

**Definition**

> demoteUser()

**Arguments**

| any | userId |
|-----|--------|

### farmPropertyChanged

**Description**

> Economy

**Definition**

> farmPropertyChanged()

**Arguments**

| any | farmId |
|-----|--------|

### getActiveUsers

**Description**

> Get a list of active users. Useful for using their connection ID

**Definition**

> getActiveUsers()

### getBalance

**Description**

> Get the current account balance of the farm.

**Definition**

> getBalance()

**Return Values**

| any | Account | balance |
|-----|---------|---------|

### getColor

**Description**

> Get the farm color

**Definition**

> getColor()

**Return Values**

| any | {r,g,b} |
|-----|---------|

### getEquity

**Description**

> Get the total equity (farmlands + placeables) of the farm

**Definition**

> getEquity()

### getFarmhouse

**Description**

> Get the farmhouse associated with the farm.

**Definition**

> getFarmhouse()

**Return Values**

| any | farmhouse | placeable or nil |
|-----|-----------|------------------|

### getIconSliceId

**Description**

> Get the farm icon UVs

**Definition**

> getIconSliceId()

### getIconUVs

**Description**

> Get the farm icon UVs

**Definition**

> getIconUVs()

### getId

**Description**

> Properties

**Definition**

> getId()

### getIsContractingFor

**Description**

> Get whether this farm is contracting for given farm

**Definition**

> getIsContractingFor()

**Arguments**

| any | farmId |
|-----|--------|

### getLoan

**Description**

> Get the current loan of the farm.

**Definition**

> getLoan()

**Return Values**

| any | Loan |
|-----|------|

### getNumActivePlayers

**Description**

> Get the number of players in the farm that are currently online

**Definition**

> getNumActivePlayers()

### getNumPlayers

**Description**

> Get the number of players in the farm

**Definition**

> getNumPlayers()

### getSleepCamera

**Description**

> Get the sleep camera.

**Definition**

> getSleepCamera()

**Return Values**

| any | Camera | or nil if no farmhouse. |
|-----|--------|-------------------------|

### getSpawnPoint

**Description**

> Get the spawnpoint associated with the farm(house).

**Definition**

> getSpawnPoint()

**Return Values**

| any | spawnpoint | node or the career spawnpoint node. |
|-----|------------|-------------------------------------|

### getUserPermissions

**Description**

> Get the farm permissions of a user.

**Definition**

> getUserPermissions(userId User)

**Arguments**

| userId | User | ID |
|--------|------|----|

**Return Values**

| userId | Permission | hash table {permission=} |
|--------|------------|--------------------------|

### isUserFarmManager

**Description**

> Determine if a user is a manager of this farm.

**Definition**

> isUserFarmManager(userId User)

**Arguments**

| userId | User | ID |
|--------|------|----|

**Return Values**

| userId | True | if the user is a manager of this farm, false otherwise |
|--------|------|--------------------------------------------------------|

### loadFromXMLFile

**Description**

> Load the farm from the savegame

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

### merge

**Description**

> Merge another farm into this farm. Used for creating an SP game from an MP game. (this is mutating)

**Definition**

> merge(table other)

**Arguments**

| table | other | Another Farm |
|-------|-------|--------------|

### new

**Description**

> Create a new farm. Do not call directly! Only use the farm manager and createFarm()

**Definition**

> new()

**Arguments**

| any | isServer  |
|-----|-----------|
| any | isClient  |
| any | spectator |
| any | customMt  |

### onUserJoinGame

**Description**

> Called when a user joins the game. Active users is updated, and for spectator.
> a new user might be added. Server only.

**Definition**

> onUserJoinGame()

**Arguments**

| any | uniqueUserId |
|-----|--------------|
| any | userId       |
| any | user         |

### onUserQuitGame

**Description**

> Called when a user quits the game. The active user list is updated. Server only.

**Definition**

> onUserQuitGame()

**Arguments**

| any | userId |
|-----|--------|

### promoteUser

**Description**

> Promote a user to farm manager.

**Definition**

> promoteUser()

**Arguments**

| any | userId |
|-----|--------|

### removeUser

**Description**

> Remove a user from the farm.

**Definition**

> removeUser()

**Arguments**

| any | userId |
|-----|--------|

### resetToSingleplayer

**Description**

> Reset the farm to a singleplayer state by removing all players and adding a new single player with all permissions

**Definition**

> resetToSingleplayer()

### saveToXMLFile

**Description**

> Save the farm to the savegame

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

### setIsContractingFor

**Description**

> Update contracting status

**Definition**

> setIsContractingFor(noSendEvent boolean, , )

**Arguments**

| noSendEvent | boolean       | Send no event, forces setting of actual value without server feedback |
|-------------|---------------|-----------------------------------------------------------------------|
| any         | isContracting |                                                                       |
| any         | noSendEvent   |                                                                       |

### setUserPermission

**Description**

> Set a user's permission in this farm.

**Definition**

> setUserPermission(userId User, string permission, boolean hasPermission)

**Arguments**

| userId  | User          | ID                                                          |
|---------|---------------|-------------------------------------------------------------|
| string  | permission    | Permission key from Farm.PERMISSION                         |
| boolean | hasPermission | True if the permission is to be granted, false to be denied |

### updateMaxLoan

**Description**

> Re-calculate the maximum loan

**Definition**

> updateMaxLoan()