class ArenaController < ApplicationController

  include FightLoggerHelper

  skip_before_filter :verify_authenticity_token

  def show
    @arena = Arena.create!
    @characters = Character.all
  end

  def fight
    winner = Arena.find(params[:arena_id]).fight
    render json: {
      winner: winner.id,
      log: FightLoggerHelper.get_log
    }
  end

  def choose_player
    _permitted = params.permit(:position, :player, :arena)
    arena = Arena.find(_permitted[:arena])
    player = Character.find(_permitted[:player])
    return if ([_permitted[:position]] & %w(left right)).empty?
    if _permitted[:position] == "left"
      arena.player_1 = player
    else
      arena.player_2 = player
    end
    arena.save!
    render json: {
      player_1: {
        id: arena.player_1.try(:id),
        name: arena.player_1.try(:name),
      },
      player_2: {
        id: arena.player_2.try(:id),
        name: arena.player_2.try(:name),
      }
    }
  end

end