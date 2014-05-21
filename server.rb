require 'sinatra'
require 'csv'
require 'pry'

def roster_hash
  roster =[]
  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    rosters = {
      first_name: row ["first_name"],
      last_name: row["last_name"],
      position: row["position"],
      team: row["team"]
    }
    roster << rosters
  end
  roster
end

get '/' do
 @rosters = roster_hash
 teams_array = []
 positions_array = []
  @rosters.each do |hash|
    if !teams_array.include? hash[:team]
      teams_array << hash[:team]
    end
    if !positions_array.include? hash[:position]
      positions_array << hash[:position]
    end
  end
  @teams_array = teams_array
  @positions_array = positions_array
 erb :index
end

get '/roster/:team' do
  @rosters = roster_hash
  @rosters.find do |each_hash|
    each_hash[:team] == params[:team]
  end
  erb :teams
end

get '/position/:position' do
  @rosters = roster_hash
  @rosters.find do |each_hash|
    each_hash[:position] == params[:position]
  end
  erb :positions
end

post '/add' do
  new_first = params['add_first']
  new_last = params['add_last']
  new_team = params['team']
  new_position = params['position']
  new_entry = "#{new_first},#{new_last},#{new_position},#{new_team}"
  File.open('lackp_starting_rosters.csv', 'a') do |file|
    file.puts(new_entry)
  end

  redirect '/position/"#{new_team}'
end






