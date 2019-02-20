# frozen_string_literal: true

require 'grid_scan'

RSpec.describe 'AStar' do
  describe 'Astar::find_path_length' do
    context 'given a simple 3x3, starting at 0,0 and target at 2,2' do
      let(:start) {[0, 0]}
      let(:target) {[2, 2]}
      let(:grid) do
        [[0, 0, 0],
         [0, 0, 0],
         [0, 0, 0]]
      end

      it 'reaches the target in 4 moves' do
        expect(GridScan.new(start, grid, target).find_path_length).to eq(4)
      end
    end

    context 'given a simple 3x3, starting at 0,0 and target at 2,2, with obstacle at 1,1' do
      let(:start) {[0, 0]}
      let(:target) {[2, 2]}
      let(:obstacle) {[1,1]}
      let(:grid) do
        [[0, 0, 0],
         [0, 1, 0],
         [0, 0, 0]]
      end
      let(:astar) { GridScan.new(start, grid, target) }

      it 'reaches the target in 4 moves' do
        expect(astar.find_path_length).to eq(4)
      end

      it 'does not evaluate the obstacle' do
        expect(astar.find_path_length).to eq(4)
        expect(astar.paths[obstacle]).to be_nil
      end
    end

    context 'given a simple 3x3, starting at 0,0 and target at 0,2, with obstacles' do
      let(:start) {[0, 0]}
      let(:target) {[2, 0]}
      let(:grid) do
        [[0, 0, 0],
         [1, 1, 0],
         [0, 0, 0]]
      end
      let(:astar) { GridScan.new(start, grid, target) }

      it 'does not evaluate the obstacles, gets there in 6 moves' do
        expect(astar.find_path_length).to eq(6)
        expect(astar.paths[[1,0]]).to be_nil
        expect(astar.paths[[1,1]]).to be_nil
      end
    end

    context 'given a simple 3x3, starting at 0,0 and target at 0,2, that is impassable' do
      let(:start) {[0, 0]}
      let(:target) {[2, 0]}
      let(:grid) do
        [[0, 0, 0],
         [1, 1, 1],
         [0, 0, 0]]
      end
      let(:astar) { GridScan.new(start, grid, target) }

      it 'does not evaluate the obstacles, raises' do
        expect { astar.find_path_length }.to raise_exception(GridScan::UnreachableTarget)
        expect(astar.paths[[1,0]]).to be_nil
        expect(astar.paths[[1,1]]).to be_nil
        expect(astar.paths[[1,2]]).to be_nil
      end
    end

    context 'given a simple 3x3, starting at 0,0, with unknown target' do
      let(:start) {[0, 0]}
      let(:grid) do
        [[0, 0, 0],
         [9, 1, 1],
         [0, 0, 0]]
      end
      let(:astar) { GridScan.new(start, grid) }

      it 'finds the target' do
        expect(astar.find_path_length).to eq(1)
        expect(astar.paths[[1,1]]).to be_nil
        expect(astar.paths[[1,2]]).to be_nil
      end
    end
  end
end