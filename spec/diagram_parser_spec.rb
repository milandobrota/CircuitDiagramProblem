require 'circuit_diagram_problem'

describe DiagramParser do

  before :all do
    @parser = DiagramParser.new('spec/diagrams/simple_circuits.txt')
  end

  it 'should parse the file' do
    @parser.matrix.size.should == 19 
    @parser.matrix.first.should == "0-------------|\n"
  end

  it 'should find lightbulbs' do
    lightbulbs = @parser.lightbulbs
    lightbulbs.size.should == 3
    lightbulbs.first.should == [26,2]
  end

  it 'should parse the diagram' do
    @parser.circuits.should == [["O", ["0", "1"]], ["X", [["A", ["0", "1"]], ["N", ["1"]]]], ["X", [["O", ["0", "1"]], ["X", ["1", "1"]]]]]
  end

  it 'should solve circuits' do
    @parser.solve_circuits.should == ['1', '0', '1']
  end

  it 'should solve complex circuits' do
    parser = DiagramParser.new('spec/diagrams/complex_circuits.txt')
    parser.solve_circuits.should == ["1", "1", "1", "0", "0", "1", "1", "0"]
  end

end
