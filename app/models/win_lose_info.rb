class WinLoseInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち", },
    { key: :lose, name: "負け", },
  ]
end
