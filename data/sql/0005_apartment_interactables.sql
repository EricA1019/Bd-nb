-- Hop 8.1: More apartment interactables and flavor texts
-- Adds fridge (F), closet (L), nightstand drawer (D), shower (S), kitchen cabinet (K)
-- Keeps existing markers: bed (B), note (N), cabinet (C), mirror (M), doors (+ /)

-- Update the apartment map
DELETE FROM ascii_art WHERE key='apartment_map';
INSERT INTO ascii_art (key, art) VALUES ('apartment_map', '
################################################################################
#...............#####+++++++++############################.....................#
#..BD...........#...#.........#.........................#......................#
#..L............#...#....M....#.........................#......................#
#...............#...#.........#.........................#......................#
#...............#####.........+.........................#......................#
#...................#.........#.........................#......................#
#...................#..N..K.F.#.........................#......................#
#...................#.........#.........................#......................#
#...................#########/###########################......................#
#..................................................C....S......................#
#..............................................................................#
#.....@........................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
################################################################################
');

-- Flavor texts and interaction copy
DELETE FROM lore WHERE key='shower_flavor';
INSERT INTO lore (key, text) VALUES ('shower_flavor', 'Cold water sputters from the showerhead. Not today.');
DELETE FROM lore WHERE key='drawer_model10';
INSERT INTO lore (key, text) VALUES ('drawer_model10', 'In the nightstand drawer: a well-worn S&W Model 10 in .38 Special.');
DELETE FROM lore WHERE key='closet_jacket';
INSERT INTO lore (key, text) VALUES ('closet_jacket', "Your old leather jacket hangs heavy. You slip it on; it still fits.");
DELETE FROM lore WHERE key='kitchen_whiskey';
INSERT INTO lore (key, text) VALUES ('kitchen_whiskey', 'A bottle of cheap whiskey tucked behind the spices. It will do.');
DELETE FROM lore WHERE key='fridge_text';
INSERT INTO lore (key, text) VALUES ('fridge_text', 'The fridge hums. Inside: stale bread, a lone egg, and regret.');
