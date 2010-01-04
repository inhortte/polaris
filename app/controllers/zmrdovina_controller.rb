class ZmrdovinaController < ApplicationController
  require 'ubygems'
  require_gem 'hpricot'
  require 'net/http'

  def index
    redirect_to :action => :allmusic
  end

  def allmusic
    res = Net::HTTP.post_form(URI.parse('http://www.allmusic.com/cg/amg.dll'),{ 'P' => 'amg','sql' => 'genesis foxtrot','opt1' => '1'})
    @body = res.body
  end
end
