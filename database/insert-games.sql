-- Insert sample games for dementia care
INSERT INTO game (name, description) VALUES 
('Memory Card Matching', 'A classic memory game where patients match pairs of cards to improve cognitive function and memory recall'),
('Photo Recognition', 'Interactive photo recognition activities to help maintain visual memory and recall of familiar faces and places'),
('Simple Puzzle Games', 'Easy-to-solve puzzles designed to enhance problem-solving skills and maintain cognitive abilities')
ON CONFLICT (name) DO NOTHING;
