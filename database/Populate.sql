USE Quackstagram;

-- Clear existing data in FK-safe order
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Notification;
TRUNCATE TABLE `Like`;
TRUNCATE TABLE Comment;
TRUNCATE TABLE Follow;
TRUNCATE TABLE Post;
TRUNCATE TABLE User;
SET FOREIGN_KEY_CHECKS = 1;

-- =====================
-- USERS
-- =====================
INSERT INTO User (username, password, bio) VALUES
('checkpointmember', 'passing123',  'Testing the account for checkpoint'),
('alice_wanders',    'travel2024',  'Exploring the world one city at a time. Based in Amsterdam.'),
('bob_codes',        'dev_life99',  'Full-stack developer. Coffee enthusiast. Bug squasher.'),
('carol_creates',    'art4life!',   'Digital artist & illustrator. Commissions open!'),
('dan_eats',         'foodie99',    'Restaurant critic | Michelin guide contributor | Food is love.'),
('eva_runs',         'marathon24',  'Marathon runner & fitness coach. 5AM club member.'),
('frank_photos',     'shutter_f8',  'Landscape photographer. Sony A7IV. IG: @frankphotos'),
('grace_reads',      'bookworm1',   'Reading 100 books this year. Currently: The Name of the Wind.'),
('henry_games',      'ctrl_alt_w',  'Speedrunner. Dark Souls veteran. GameDev hobbyist.'),
('iris_bakes',       'sourdough23', 'Pastry chef at Hotel de Paris. Sourdough obsessed.'),
('jake_travels',     'backpack47',  'Visited 47 countries. Living out of a 40L pack.'),
('kate_designs',     'pixels_ux',   'UI/UX designer. Design systems advocate.'),
('leo_music',        'bassline99',  'Bassist. Music producer. Jazz & electronic crossover.'),
('mia_writes',       'press2024',   'Tech journalist. DMs open for tips.'),
('noah_builds',      'arch_dev',    'Architect turned developer. Building digital things now.');

-- Users without posts — exercises LIST_USERS_WITHOUT_POSTS view
INSERT INTO User (username, password, bio) VALUES
('new_user_01', 'welcome1',  'Just joined Quackstagram!'),
('new_user_02', 'welcome2',  'Still figuring out how to post.'),
('lurker_max',  'maxpass99', 'I only watch. Never post.');

-- =====================
-- POSTS (20 posts across active users)
-- =====================
INSERT INTO Post (username, image_path, caption, posted_at) VALUES
('alice_wanders', 'uploads/alice_amsterdam.jpg',  'Morning canals in Amsterdam. Nothing beats this view at sunrise.',            '2025-01-10 08:23:00'),
('alice_wanders', 'uploads/alice_lisbon.jpg',     'Lisbon calling. Pasteis de nata and golden tiles everywhere.',                '2025-02-14 14:05:00'),
('bob_codes',     'uploads/bob_setup.jpg',        'Finally upgraded my home office. Dual 4K monitors, mechanical keyboard. Productivity unlocked.', '2025-01-18 19:44:00'),
('bob_codes',     'uploads/bob_coffee.jpg',       'Third coffee of the day. The code will compile eventually.',                  '2025-03-02 11:22:00'),
('carol_creates', 'uploads/carol_neon_city.jpg',  'New digital painting: Neon City. Spent 40 hours on this one. Worth it.',     '2025-01-25 16:30:00'),
('carol_creates', 'uploads/carol_commission.jpg', 'Character design commission done! Feedback welcome.',                        '2025-02-20 20:15:00'),
('dan_eats',      'uploads/dan_ramen.jpg',        'Best tonkotsu ramen in Maastricht. The broth is a 12-hour labour of love. 10/10.', '2025-01-30 13:00:00'),
('dan_eats',      'uploads/dan_omakase.jpg',      'Omakase at Nobu. 14 courses. Every one a highlight. The wagyu nigiri changed my life.', '2025-03-15 21:00:00'),
('eva_runs',      'uploads/eva_marathon.jpg',     'Crossed the finish line at Rotterdam Marathon. 3:42:17. New PR!',             '2025-04-07 12:00:00'),
('eva_runs',      'uploads/eva_morning.jpg',      'Day 127 of 5AM runs. Rain or shine. Your excuses are just thoughts.',         '2025-02-08 05:30:00'),
('frank_photos',  'uploads/frank_dolomites.jpg',  'The Dolomites at golden hour. Sony A7IV, 24mm f/1.4. No filters. Nature wins.', '2025-01-05 17:45:00'),
('frank_photos',  'uploads/frank_aurora.jpg',     'Aurora borealis over Reykjavik. Waited 3 nights for this. Worth every cold second.', '2025-02-28 23:10:00'),
('grace_reads',   'uploads/grace_shelf.jpg',      'Current shelf situation. Send help (and more bookshelves). Book 34 of 100 done!', '2025-03-10 15:20:00'),
('henry_games',   'uploads/henry_station.jpg',    'Gaming battlestation complete. 240Hz monitor, RGB everything. Ready for ranked.', '2025-01-22 21:00:00'),
('iris_bakes',    'uploads/iris_sourdough.jpg',   'Today''s loaf: 78% hydration sourdough with rosemary and sea salt. The crumb is perfect.', '2025-02-05 09:00:00'),
('iris_bakes',    'uploads/iris_croissant.jpg',   '72-hour croissants. 27 layers of butter. Pure patience.',                    '2025-03-20 08:30:00'),
('jake_travels',  'uploads/jake_halong.jpg',      'Ha Long Bay, Vietnam. Words cannot do it justice. Photo barely can either.', '2025-01-15 06:00:00'),
('kate_designs',  'uploads/kate_system.jpg',      'Shipped our new design system: 200+ components, dark mode, accessibility baked in.', '2025-02-10 17:00:00'),
('leo_music',     'uploads/leo_studio.jpg',       'New track dropping Friday. This one hits different. Studio vibes at 2AM.',   '2025-03-05 02:15:00'),
('mia_writes',    'uploads/mia_interview.jpg',    'Just wrapped an interview with the CEO of OpenAI. Article drops Monday. Big news inside.', '2025-04-01 18:00:00');

-- =====================
-- COMMENTS
-- =====================
INSERT INTO Comment (post_id, username, content, timestamp) VALUES
-- Post 1: alice amsterdam
(1, 'jake_travels', 'Amsterdam is magic. Did you cycle along the Prinsengracht?',             '2025-01-10 09:00:00'),
(1, 'frank_photos', 'Beautiful light! What time exactly? Looks like the blue hour.',           '2025-01-10 10:15:00'),
(1, 'grace_reads',  'I need to visit Amsterdam so badly. It looks like a fairy tale.',         '2025-01-10 12:30:00'),
(1, 'mia_writes',   'Stunning! Working on a travel piece — mind if I feature this?',           '2025-01-11 08:00:00'),
-- Post 3: bob setup
(3, 'kate_designs', 'Which monitors? The setup looks super clean!',                            '2025-01-18 20:00:00'),
(3, 'henry_games',  'Dual 4K is the dream. Jealous of that desk space.',                       '2025-01-19 09:30:00'),
(3, 'carol_creates','As a fellow dual monitor person — welcome to the club. No going back.',   '2025-01-19 11:45:00'),
-- Post 5: carol neon city
(5, 'alice_wanders','This is absolutely stunning Carol! The neon reflections are incredible.', '2025-01-25 17:00:00'),
(5, 'mia_writes',   'I would buy a print of this in a heartbeat. Do you sell?',                '2025-01-25 18:30:00'),
(5, 'kate_designs', '40 hours well spent. The colour palette is chef''s kiss.',                '2025-01-26 09:00:00'),
(5, 'leo_music',    'This would make a perfect album cover. Seriously DM me.',                 '2025-01-26 14:00:00'),
-- Post 9: eva marathon
(9, 'bob_codes',    'Congrats!! 3:42 is amazing. I can barely run 5K.',                        '2025-04-07 13:00:00'),
(9, 'alice_wanders','YESSS EVA!! So proud of you!!',                                           '2025-04-07 13:30:00'),
(9, 'iris_bakes',   'You deserve ALL the food. Come by the bakery, I''ll make a recovery cake.','2025-04-07 14:00:00'),
-- Post 12: frank aurora
(12, 'alice_wanders','I''ve been trying to see the aurora for years. This is goals.',          '2025-03-01 08:00:00'),
(12, 'jake_travels', '3 nights of waiting is nothing for a shot like this. Incredible.',       '2025-03-01 10:00:00'),
(12, 'grace_reads',  'This looks like the cover of a fantasy novel. Breathtaking.',            '2025-03-01 12:00:00'),
-- Post 15: iris sourdough
(15, 'dan_eats',    '78% hydration is bold. What starter are you using?',                      '2025-02-05 10:00:00'),
(15, 'grace_reads', 'I''ve been failing at sourdough for months. How do you do it??',          '2025-02-05 11:00:00'),
(15, 'bob_codes',   'That crust though. I can almost hear it crackling through the screen.',   '2025-02-05 13:00:00'),
-- Post 19: leo studio
(19, 'henry_games', '2AM studio sessions hit different. Cannot wait for Friday.',              '2025-03-05 08:00:00'),
(19, 'carol_creates','The vibes are immaculate. What genre is this one?',                      '2025-03-05 09:00:00'),
(19, 'mia_writes',  'Already writing the review in my head. Drop that link the second it''s live.', '2025-03-05 10:30:00'),
-- Post 20: mia interview
(20, 'bob_codes',   'Can''t wait to read this. Big news is an understatement lately.',         '2025-04-01 19:00:00'),
(20, 'alice_wanders','The tech world is going to be buzzing. Great work Mia!',                 '2025-04-01 20:00:00'),
(20, 'kate_designs','Monday cannot come soon enough. Subscribed to your newsletter.',          '2025-04-01 21:00:00');

-- =====================
-- FOLLOWS
-- =====================
INSERT INTO Follow (follower_username, followed_username) VALUES
('bob_codes',        'alice_wanders'),
('carol_creates',    'alice_wanders'),
('jake_travels',     'alice_wanders'),
('frank_photos',     'alice_wanders'),
('alice_wanders',    'frank_photos'),
('alice_wanders',    'jake_travels'),
('alice_wanders',    'carol_creates'),
('kate_designs',     'carol_creates'),
('mia_writes',       'carol_creates'),
('leo_music',        'carol_creates'),
('dan_eats',         'iris_bakes'),
('grace_reads',      'mia_writes'),
('henry_games',      'leo_music'),
('eva_runs',         'bob_codes'),
('noah_builds',      'kate_designs'),
('checkpointmember', 'alice_wanders'),
('bob_codes',        'mia_writes'),
('iris_bakes',       'dan_eats'),
('jake_travels',     'frank_photos'),
('mia_writes',       'bob_codes');

-- =====================
-- LIKES (distributed across posts)
-- =====================
INSERT INTO `Like` (post_id, username) VALUES
-- Post 1: alice amsterdam
(1, 'bob_codes'), (1, 'carol_creates'), (1, 'jake_travels'), (1, 'frank_photos'),
(1, 'grace_reads'), (1, 'henry_games'), (1, 'eva_runs'), (1, 'dan_eats'),
(1, 'noah_builds'), (1, 'checkpointmember'),
-- Post 3: bob setup
(3, 'alice_wanders'), (3, 'henry_games'), (3, 'kate_designs'), (3, 'eva_runs'), (3, 'mia_writes'),
-- Post 5: carol neon city — viral post (main users)
(5, 'alice_wanders'), (5, 'bob_codes'),  (5, 'dan_eats'),    (5, 'eva_runs'),
(5, 'frank_photos'),  (5, 'grace_reads'),(5, 'henry_games'), (5, 'iris_bakes'),
(5, 'jake_travels'),  (5, 'kate_designs'),(5, 'leo_music'),  (5, 'mia_writes'),
(5, 'noah_builds'),   (5, 'checkpointmember'),
-- Post 9: eva marathon
(9, 'alice_wanders'), (9, 'bob_codes'),  (9, 'carol_creates'),(9, 'dan_eats'),
(9, 'frank_photos'),  (9, 'grace_reads'),(9, 'henry_games'), (9, 'iris_bakes'),
(9, 'jake_travels'),  (9, 'kate_designs'),(9, 'leo_music'),  (9, 'mia_writes'),
-- Post 11: frank dolomites
(11, 'alice_wanders'),(11, 'bob_codes'), (11, 'carol_creates'),
(11, 'grace_reads'),  (11, 'jake_travels'), (11, 'eva_runs'),
-- Post 12: frank aurora
(12, 'alice_wanders'),(12, 'bob_codes'), (12, 'carol_creates'),(12, 'dan_eats'),
(12, 'eva_runs'),     (12, 'grace_reads'),(12, 'henry_games'), (12, 'iris_bakes'),
(12, 'jake_travels'), (12, 'kate_designs'),(12, 'leo_music'),  (12, 'mia_writes'),
(12, 'noah_builds'),  (12, 'checkpointmember'),
-- Post 15: iris sourdough
(15, 'alice_wanders'),(15, 'bob_codes'), (15, 'carol_creates'),(15, 'dan_eats'),
(15, 'eva_runs'),     (15, 'frank_photos'),(15, 'grace_reads'),(15, 'henry_games'),
-- Post 19: leo studio
(19, 'alice_wanders'),(19, 'bob_codes'), (19, 'carol_creates'),(19, 'henry_games'),
(19, 'kate_designs'), (19, 'mia_writes'),
-- Post 20: mia interview
(20, 'alice_wanders'),(20, 'bob_codes'), (20, 'carol_creates'),(20, 'dan_eats'),
(20, 'eva_runs'),     (20, 'frank_photos'),(20, 'grace_reads'),(20, 'henry_games'),
(20, 'iris_bakes'),   (20, 'jake_travels'),(20, 'kate_designs'),(20, 'noah_builds');

-- =====================
-- BULK USERS + LIKES — makes SHOW_POPULAR_POSTS return results
-- Post 5 (carol's Neon City) already has 14 likes from main users.
-- 90 bulk users bring it to 104 likes, exceeding the view's HAVING > 100 threshold.
-- =====================
INSERT INTO User (username, password, bio) VALUES
('bulk_u001','bp001','Test account'),('bulk_u002','bp002','Test account'),
('bulk_u003','bp003','Test account'),('bulk_u004','bp004','Test account'),
('bulk_u005','bp005','Test account'),('bulk_u006','bp006','Test account'),
('bulk_u007','bp007','Test account'),('bulk_u008','bp008','Test account'),
('bulk_u009','bp009','Test account'),('bulk_u010','bp010','Test account'),
('bulk_u011','bp011','Test account'),('bulk_u012','bp012','Test account'),
('bulk_u013','bp013','Test account'),('bulk_u014','bp014','Test account'),
('bulk_u015','bp015','Test account'),('bulk_u016','bp016','Test account'),
('bulk_u017','bp017','Test account'),('bulk_u018','bp018','Test account'),
('bulk_u019','bp019','Test account'),('bulk_u020','bp020','Test account'),
('bulk_u021','bp021','Test account'),('bulk_u022','bp022','Test account'),
('bulk_u023','bp023','Test account'),('bulk_u024','bp024','Test account'),
('bulk_u025','bp025','Test account'),('bulk_u026','bp026','Test account'),
('bulk_u027','bp027','Test account'),('bulk_u028','bp028','Test account'),
('bulk_u029','bp029','Test account'),('bulk_u030','bp030','Test account'),
('bulk_u031','bp031','Test account'),('bulk_u032','bp032','Test account'),
('bulk_u033','bp033','Test account'),('bulk_u034','bp034','Test account'),
('bulk_u035','bp035','Test account'),('bulk_u036','bp036','Test account'),
('bulk_u037','bp037','Test account'),('bulk_u038','bp038','Test account'),
('bulk_u039','bp039','Test account'),('bulk_u040','bp040','Test account'),
('bulk_u041','bp041','Test account'),('bulk_u042','bp042','Test account'),
('bulk_u043','bp043','Test account'),('bulk_u044','bp044','Test account'),
('bulk_u045','bp045','Test account'),('bulk_u046','bp046','Test account'),
('bulk_u047','bp047','Test account'),('bulk_u048','bp048','Test account'),
('bulk_u049','bp049','Test account'),('bulk_u050','bp050','Test account'),
('bulk_u051','bp051','Test account'),('bulk_u052','bp052','Test account'),
('bulk_u053','bp053','Test account'),('bulk_u054','bp054','Test account'),
('bulk_u055','bp055','Test account'),('bulk_u056','bp056','Test account'),
('bulk_u057','bp057','Test account'),('bulk_u058','bp058','Test account'),
('bulk_u059','bp059','Test account'),('bulk_u060','bp060','Test account'),
('bulk_u061','bp061','Test account'),('bulk_u062','bp062','Test account'),
('bulk_u063','bp063','Test account'),('bulk_u064','bp064','Test account'),
('bulk_u065','bp065','Test account'),('bulk_u066','bp066','Test account'),
('bulk_u067','bp067','Test account'),('bulk_u068','bp068','Test account'),
('bulk_u069','bp069','Test account'),('bulk_u070','bp070','Test account'),
('bulk_u071','bp071','Test account'),('bulk_u072','bp072','Test account'),
('bulk_u073','bp073','Test account'),('bulk_u074','bp074','Test account'),
('bulk_u075','bp075','Test account'),('bulk_u076','bp076','Test account'),
('bulk_u077','bp077','Test account'),('bulk_u078','bp078','Test account'),
('bulk_u079','bp079','Test account'),('bulk_u080','bp080','Test account'),
('bulk_u081','bp081','Test account'),('bulk_u082','bp082','Test account'),
('bulk_u083','bp083','Test account'),('bulk_u084','bp084','Test account'),
('bulk_u085','bp085','Test account'),('bulk_u086','bp086','Test account'),
('bulk_u087','bp087','Test account'),('bulk_u088','bp088','Test account'),
('bulk_u089','bp089','Test account'),('bulk_u090','bp090','Test account');

INSERT INTO `Like` (post_id, username) VALUES
(5,'bulk_u001'),(5,'bulk_u002'),(5,'bulk_u003'),(5,'bulk_u004'),(5,'bulk_u005'),
(5,'bulk_u006'),(5,'bulk_u007'),(5,'bulk_u008'),(5,'bulk_u009'),(5,'bulk_u010'),
(5,'bulk_u011'),(5,'bulk_u012'),(5,'bulk_u013'),(5,'bulk_u014'),(5,'bulk_u015'),
(5,'bulk_u016'),(5,'bulk_u017'),(5,'bulk_u018'),(5,'bulk_u019'),(5,'bulk_u020'),
(5,'bulk_u021'),(5,'bulk_u022'),(5,'bulk_u023'),(5,'bulk_u024'),(5,'bulk_u025'),
(5,'bulk_u026'),(5,'bulk_u027'),(5,'bulk_u028'),(5,'bulk_u029'),(5,'bulk_u030'),
(5,'bulk_u031'),(5,'bulk_u032'),(5,'bulk_u033'),(5,'bulk_u034'),(5,'bulk_u035'),
(5,'bulk_u036'),(5,'bulk_u037'),(5,'bulk_u038'),(5,'bulk_u039'),(5,'bulk_u040'),
(5,'bulk_u041'),(5,'bulk_u042'),(5,'bulk_u043'),(5,'bulk_u044'),(5,'bulk_u045'),
(5,'bulk_u046'),(5,'bulk_u047'),(5,'bulk_u048'),(5,'bulk_u049'),(5,'bulk_u050'),
(5,'bulk_u051'),(5,'bulk_u052'),(5,'bulk_u053'),(5,'bulk_u054'),(5,'bulk_u055'),
(5,'bulk_u056'),(5,'bulk_u057'),(5,'bulk_u058'),(5,'bulk_u059'),(5,'bulk_u060'),
(5,'bulk_u061'),(5,'bulk_u062'),(5,'bulk_u063'),(5,'bulk_u064'),(5,'bulk_u065'),
(5,'bulk_u066'),(5,'bulk_u067'),(5,'bulk_u068'),(5,'bulk_u069'),(5,'bulk_u070'),
(5,'bulk_u071'),(5,'bulk_u072'),(5,'bulk_u073'),(5,'bulk_u074'),(5,'bulk_u075'),
(5,'bulk_u076'),(5,'bulk_u077'),(5,'bulk_u078'),(5,'bulk_u079'),(5,'bulk_u080'),
(5,'bulk_u081'),(5,'bulk_u082'),(5,'bulk_u083'),(5,'bulk_u084'),(5,'bulk_u085'),
(5,'bulk_u086'),(5,'bulk_u087'),(5,'bulk_u088'),(5,'bulk_u089'),(5,'bulk_u090');

-- =====================
-- NOTIFICATIONS
-- =====================
INSERT INTO Notification (username, post_id, notified_at) VALUES
('alice_wanders', 1,  '2025-01-10 09:01:00'),
('alice_wanders', 1,  '2025-01-10 10:16:00'),
('alice_wanders', 1,  '2025-01-10 12:31:00'),
('alice_wanders', 2,  '2025-02-14 15:00:00'),
('bob_codes',     3,  '2025-01-18 20:01:00'),
('bob_codes',     3,  '2025-01-19 09:31:00'),
('carol_creates', 5,  '2025-01-25 17:01:00'),
('carol_creates', 5,  '2025-01-25 18:31:00'),
('carol_creates', 5,  '2025-01-26 09:01:00'),
('carol_creates', 6,  '2025-02-20 21:00:00'),
('eva_runs',      9,  '2025-04-07 13:01:00'),
('eva_runs',      9,  '2025-04-07 13:31:00'),
('frank_photos',  12, '2025-03-01 08:01:00'),
('iris_bakes',    15, '2025-02-05 10:01:00'),
('iris_bakes',    16, '2025-03-20 09:00:00'),
('leo_music',     19, '2025-03-05 08:01:00'),
('mia_writes',    20, '2025-04-01 19:01:00'),
('mia_writes',    20, '2025-04-01 20:01:00');
