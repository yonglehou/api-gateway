local util = require "util"

describe("strip trailing slash", function()
  it("removes the trailing slash", function()
    assert.are.equal("/foo/bar", util.strip_trailing_slash("/foo/bar/"))
    assert.are.equal("/foo/bar", util.strip_trailing_slash("/foo/bar//"))
    assert.are.equal("", util.strip_trailing_slash("/"))
  end)

  it("does nothing to a string without a trailing slash", function()
    assert.are.equal("foobar", util.strip_trailing_slash("foobar"))
    assert.are.equal("", util.strip_trailing_slash(""))
  end)
end)


describe("strip leading slash", function()
  it("removes the leading slash", function()
    assert.are.equal("foo/bar/", util.strip_leading_slash("/foo/bar/"))
    assert.are.equal("foo/bar/", util.strip_leading_slash("//foo/bar/"))
    assert.are.equal("", util.strip_leading_slash("/"))
  end)

  it("does nothing to a string without a leading slash", function()
    assert.are.equal("foobar", util.strip_leading_slash("foobar"))
    assert.are.equal("", util.strip_leading_slash(""))
  end)
end)

describe("get first part of url", function()
  it("successfully provides leading url component", function()
    assert.are.equal("some", util.get_url_prefix("/some/url"))
    assert.are.equal("some", util.get_url_prefix("some/url"))
    assert.are.equal("some", util.get_url_prefix("/some/url/very/long/url"))
    assert.are.equal("some", util.get_url_prefix("/some/"))
    assert.are.equal("some", util.get_url_prefix("/some"))
    assert.are.equal("some", util.get_url_prefix("///some////ignore/this"))
    assert.are.equal("some", util.get_url_prefix("///////some"))
  end)

  it("fail to provide leading url component", function()
    assert.are.equal("", util.get_url_prefix(""))
    assert.are.equal("", util.get_url_prefix("/"))
  end)
end)


describe("get rest of url after prefix", function()
  it("successfully provides rest of url", function()
    assert.are.equal("/url", util.get_rest_after_url_prefix("/some/url"))
    assert.are.equal("/url/", util.get_rest_after_url_prefix("some/url/"))
    assert.are.equal("/url/very/long/url", util.get_rest_after_url_prefix("/some/url/very/long/url"))
    assert.are.equal("/", util.get_rest_after_url_prefix("/some/"))
    assert.are.equal("///don't/ignore/this", util.get_rest_after_url_prefix("///some///don't/ignore/this"))
    assert.are.equal("/space s/i n/ u r l/work no problem", util.get_rest_after_url_prefix("/some/space s/i n/ u r l/work no problem"))
  end)

  it("rest of url is empty", function()
    assert.are.equal("", util.get_rest_after_url_prefix("/some"))
    assert.are.equal("", util.get_rest_after_url_prefix("///////some"))
    assert.are.equal("", util.get_rest_after_url_prefix(""))
    assert.are.equal("", util.get_rest_after_url_prefix("/"))
  end)
end)