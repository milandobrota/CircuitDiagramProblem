class DiagramParser

  attr_accessor :matrix, :lightbulbs, :circuits

  def initialize(filename)
    @matrix = []
    @lightbulbs = []
    f = File.open(filename, 'r')
    f.each_line do |line|
      @matrix << line
    end
    f.close
    find_lightbulbs
    @circuits = @lightbulbs.map {|lb| parse_circuit(lb)}
  end

  def find_lightbulbs
    @matrix.each_with_index do |row, row_number|
      potential_position = (row =~ /@/)
      @lightbulbs << [potential_position, row_number] if potential_position
    end
  end

  def parse_circuit(lightbulb)
    iteration(lightbulb, lightbulb)
  end

  def iteration(current, previous)
    branches = []
    x = current.first
    y = current.last
    current_character = @matrix[y][x].chr
    return '0' if current_character == '0'
    return '1' if current_character == '1'
    xp = previous.first
    yp = previous.last
    [[x-1,y], [x+1, y], [x, y-1], [x, y+1]].each do |(xn,yn)|
      next if xn < 0 || yn < 0      # out of bounds
      next if xn == xp && yn == yp  # no going backwards
      next if xn == x && yn == y    # no progress
      next unless @matrix[yn] && @matrix[yn][xn]
      next_character = @matrix[yn][xn].chr
      # require 'ruby-debug'; debugger if current_character != '-'
      branches << iteration([xn,yn], [x,y]) if ['-', '|', 'O', 'A', 'N', 'X', '0', '1'].include?(next_character)
      # puts branches.inspect
    end
    if ['A', 'O', 'N', 'X'].include?(current_character)
      return [current_character, branches]
    else
      return branches.first
    end
  end

  def solve_circuits
    @circuits.collect do |circuit|
      solve_circuit(circuit)
    end
  end

  def solve_circuit(circuit)
    return '0' if circuit == '0'
    return '1' if circuit == '1'
    operator = circuit.first
    boolean = nil
    case operator
    when 'O'
      params = circuit.last
      boolean = solve_circuit(params[0]) == '1' ||  solve_circuit(params[1]) == '1'
      return boolean ? '1' : '0'
    when 'A'
      params = circuit.last
      boolean = solve_circuit(params[0]) == '1' &&  solve_circuit(params[1]) == '1'
      return boolean ? '1' : '0'
    when 'X'
      params = circuit.last
      boolean = solve_circuit(params[0]) !=  solve_circuit(params[1])
      return boolean ? '1' : '0'
    when 'N'
      param = circuit.last.last
      boolean = solve_circuit(param) == '0'
      return boolean ? '1' : '0'
    end
  end

end
