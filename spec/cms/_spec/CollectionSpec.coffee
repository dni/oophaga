define ["cs!lib/model/Collection"], (Collection)->

  describe "oophaga collections", ->
    it "create new collection", ->
      collection = new Collection
      expect(collection).toBeTruthy()

    it "add model to collection", ->
      collection = new Collection
      collection.add lol:"000"
      expect(collection.length).toBeTruthy()

    it "test getValue function", ->
      collection = new Collection
      collection.add lol:"000"
      expect(collection.length).toBeTruthy()
