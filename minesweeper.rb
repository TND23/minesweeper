require 'debugger'

class Game

  attr_reader :this_board

  def won?
    # if all the bombs are flagged and all the others are revealed, true
    could_win = true
    @this_board.each do |row|
      @this_board.each do |column|
        unless ((@this_board[row][column].content == "B" && @this_board[row][column].flagged)
          || @this_board[row][column].revealed )
          could_win = false
        end
      end
    end
    could_win
  end

  def initialize(size)
    @this_board = Board.new(size)
    @user = User.new
    p "If you want to reveal a coordinate type '0,0', if you want to flag a coordinate type '0,0f'"
  end

  def prompt
    p "Please enter coordinates to click."
    @coord = gets.chomp
    x = @coord[0].to_i
    y = @coord[2].to_i
    cmd = @coord[3]
    return [x, y, cmd]
  end

  def play
    input = prompt
    if input[2] == 'f'
      @this_board.board_array[x,y].flagged
    else
      @this_board.explore([x,y])
    end
  end
end

class Tile

  attr_accessor :content, :revealed, :flagged

  def initialize
    @clicked = false
    @flagged = false
    @content = nil
    @revealed = false
  end

  def set_b
    self.content = "B"
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged = true
  end

end

class Board
  #9X9 or 16X16emn
  attr_accessor :board_array

  def to_s
    @board_size.times do |row|
      arr = []
      @board_size.times do |col|
        arr << "#{@board_array[row][col].content}"
      end
      p arr
    end

    @board_size.times do |row|
      arr = []
      @board_size.times do |col|
        if @board_array[row][col].revealed
          arr << "#{@board_array[row][col].content}"
        elsif @board_array[row][col].flagged
          arr << "F"
        else
          arr << "_"
        end
      end
      p arr
    end
  end



  def initialize(size)
    @board_size = size
    @board_array = []
    create_board(size)
  end

  def create_board(size)
    size.times do
      @board_array << []
    end
    @board_array.each do |element|
      size.times {element << Tile.new}
    end

    10.times do
      current_tile = Tile.new
      current_tile.content = "B"
      row = (0...9).to_a.sample
      col = (0...9).to_a.sample
      @board_array[row][col] = current_tile
    end

    find_values
  end

  def find_values
    @board_size.times do |row|
      @board_size.times do |column|
        populate([row, column])
      end
    end
  end

  def populate(coord)
    #if the tile at coord is already a b, skip
    x = coord[0]
    y = coord[1]
    count = 0

    if @board_array[x][y].content == "B"
      p "B"
      return "B"
    else
      array = neighbors(coord)
      array.each do |coord|
        x1 = coord[0]
        y1 = coord[1]

        if @board_array[x1][y1].content == "B"
          count+=1
        end
      end

       @board_array[x][y].content = count
       p count
    end
  end

  def neighbors(coord) #[1,4]
    x = coord[0]
    y = coord[1]
    poss_x = [x-1, x, x+1]
    poss_y = [y-1, y, y+1]
    neighbor_arr = []
    poss_x.each do |el_x|
      poss_y.each do |el_y|
        if el_x >= 0 && el_x <= @board_size - 1 && el_y >= 0 && el_y <= @board_size - 1
          neighbor_arr << [el_x, el_y]
        end
      end
    end
    neighbor_arr.delete(coord)
    neighbor_arr
  end

  def explore(coord)
    #recurse over neighbors of coord
    #no neighbors have bs ---> reaveal all neigbors
    x = coord[0]
    y = coord[1]
    tile = @board_array[x][y]

    tile.reveal
    if tile.content == 0

      neighbors_list = neighbors([x,y])
      neighbors_list.each do |n|

        x1 = n[0]
        y1 = n[1]

        if @board_array[x1][y1].revealed || @board_array[x1][y1].flagged
          next
        else
          explore(n)
        end
      end
    end

    #content of neighbor

    #if coord is not b, show self.
    #check neighbors. if none contain a b, show neighbors, and call explore on them.
  end



end

class User

  def click

  end

  def flag
  end

end

def reload
  load './minesweeper.rb'
end