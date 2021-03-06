# frozen_string_literal: true

class Notification < ApplicationRecord
  # 常に新しい日付のデータから取得
  default_scope -> { order(created_at: :desc) }
  # optional: true はbelongs_toのnilを許可
  belongs_to :content, optional: true
  belongs_to :comment, optional: true
  belongs_to :message, optional: true
  belongs_to :room,    optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
