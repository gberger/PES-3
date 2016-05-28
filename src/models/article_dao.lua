local Article = require "models/article"
local utils = require "utils"
local app = require "app"
local path = require "pl.path"
local file = require "pl.file"
local plutils = require "pl.utils"
local ObjectId = require("mongorover.luaBSONObjects").ObjectId

local M = {
  new = function(self, connection, app)
    local dao = {connection = connection}
    setmetatable(dao, {__index = self.metatable})
    return dao
  end,
}

M.metatable = {
  insert = function(self, article, uploaded_document)
    if not article or not uploaded_document then error() end
    local result = self:__collection():insert_one(article:data())
    if result.acknowledged then
      local data = utils.merge(article:data(), {id = result.inserted_id.key})
      local article = Article:new(data)
      file.copy(uploaded_document.path, self:__document_abs_path(article))
      return article
    else
      return nil
    end
  end,

  all = function(self)
    return Article:build_all(self:__find_all())
  end,

  find = function(self, id)
    return Article:new(self:__find_all({_id = ObjectId.new(id)})[1])
  end,

  download = function(self, id)
    self:__collection():update_one({_id = ObjectId.new(id)}, {["$inc"] = {downloads = 1}})
    local article = self:find(id)
    local file = plutils.readfile(self:__document_abs_path(article), true)
    return article, file
  end,
  
  __collection = function(self)
    local database = self.connection:getDatabase("pes3")
    return database:getCollection("articles")
  end,
  
  __find_all = function(self, query)
    local query = query or {}
    return utils.map_iterator(self:__collection():find(query), function(article_data)
      article_data.id = article_data._id.key
      article_data._id = nil
      return article_data
    end)
  end,
  
  __document_abs_path = function(self, article)
    return path.join(app.root, "documents", article.id .. ".pdf")
  end
}

return M