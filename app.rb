#!/usr/bin/env ruby
#coding: utf-8

require 'sinatra'

configure do
  use Rack::CommonLogger
end

get '/favicon.ico' do
  halt
end

get '/' do
  @pad_id = `uuidgen`.chomp
  erb :pad 
end

get '/:pad_id' do |pad_id|
  @pad_id = pad_id
  begin
    @content = open("docs/#{pad_id}").read
  rescue
    @content = ''
  end
  erb :pad
end

post '/save' do
  p params
  open("docs/#{params[:pad_id]}", 'w') do |f|
    f.write(params[:content])
  end
  return "saved" if request.xhr?
  redirect "/#{params[:pad_id]}"
end

not_found do
  redirect '/'
end
