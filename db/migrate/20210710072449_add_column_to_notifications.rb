# frozen_string_literal: true

class AddColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :room_id, :integer
  end
end
