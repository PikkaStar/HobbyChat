class Report < ApplicationRecord
  belongs_to :reporter,class_name: "User",foreign_key: "reporter_id"
  belongs_to :reported,class_name: "User",foreign_key: "reported_id"
  # 通報対象のコンテンツを示すポリモーフィック関連付け
  belongs_to :content,polymorphic: true

  # 通報理由をenumで
  enum reason: {
    malicious_expression: 0,  #悪意ある表現
    inappropriate_content: 1, #不適切なコンテンツ
    misinformation: 2,        #誤った情報
    commercial_purposes: 3,   #商業目的
    spam: 4,                  #スパム
    other: 5                  #その他
  }
end
