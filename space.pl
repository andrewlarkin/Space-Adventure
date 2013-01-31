/*
*   Copyright 2013 Andrew Larkin
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*/

:- dynamic i_am_at/1, at/2, holding/1, installed/1, credits/1, sale/2, locked/1.

i_am_at(station).
credits(3000).
locked(stargate).

/* These rules define where we can jump */

path(sun, a, barren).

path(barren, a, sun).
path(barren, b, station).

path(station, a, barren).
path(station, b, red).
path(station, c, asteroid).

path(red, a, station).

path(asteroid, a, station).
path(asteroid, b, giant) :- installed(shields),!.
path(asteroid, b, giant) :- 
        write('You need shields to survive the asteroid field!'), nl,
        fail.

path(giant, a, asteroid).
path(giant, b, ice).
path(giant, c, derelect) :- 
        locked(stargate),
        write('A huge metal ring floats, inactive, in orbit.'), nl,
        !,fail.
path(giant, c, derelect).

path(ice, a, giant).

path(derelect, a, giant).

/* These rules identify a location as a shop */

shop(station).

/* This rule tells how to jump in or out of the system */

jump(Coordinate) :-
        i_am_at(Here),
        path(Here, Coordinate, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look.

jump(_) :-
        write('You cannot jump to those coordinates').
        
/* These rules define the direction letters as calls to jump/1. */

a :- jump(a),!.

b :- jump(b),!.

c :- jump(c),!.

/* These rules describe where items are */

at(ore, barren).
at(shields, red).
at(phaser, station).
at(ferret, station).
at(transmitter, station).
at(artifact, derelect).

/* These rules describe what items are equipment for your ship */

equipment(transmitter).
equipment(shields).

/* These rules indicate that items are for sale */

sale(phaser, 1000).
sale(ferret, 3000).
sale(transmitter, 2000).

/* These rules define friendly names for things */

name(sun) :- write('The Sun').
name(barren) :- write('Barren Planet').
name(station) :- write('Sanctuary Station').
name(red) :- write('Red Planet').
name(asteroid) :- write('Asteroid Field').
name(giant) :- write('Gas Giant').
name(ice) :- write('Ice Planet').
name(derelect) :- write('Alien Derelect').

name(ore) :- write('Obtanium Ore').
name(shields) :- write('X1 Energy Shields').
name(phaser) :- write('Xeno Blaster 9000').
name(ferret) :- write('Space Ferret').
name(transmitter) :- write('Mysterious Transmitter').
name(artifact) :- write('Alien Artifact').

/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(sun) :-
        write('The sun burns furiously.  You can feel the radiation seeping'), nl,
        write('into your hull.  Something in your gut tells you that you'), nl,
        write('shouldn''t stay here long.  Well, your gut and the hull'), nl,
        write('integrity alert...'), nl.
        
describe(barren) :-
        write('This planet is completely devoid of life.  The proximity'), nl,
        write('to the sun makes it most inhospitable.  You wonder what'), nl,
        write('the price of real estate would be here...'), nl.

describe(station) :-
        write('Santuary Station gleams outside of your viewport  This bustling'), nl,
        write('hub of activity is the center of all trade for the solar system.'), nl,
        write('Space captains come from all over to sell cargo, purchase supplies'), nl,
        write('and brag about their exploits.  Most captains are just looking for'), nl,
        write('a lucky break.  You''ll fit right in.'), nl, nl,
        write('As you approach the station you recieve a holo-tweet:'), nl,
        write('"Welcome to Sanctuary Station!  Scan the station to learn'), nl,
        write('about exciting opportunities for spacers like yourself!"'), nl,
        nl,
        write('There is a shop here. (type browse. to see what''s for sale)'), nl.

describe(red) :-
        write('The planet below has a deep red hue.  Your sensors are picking'), nl,
        write('up a small research facility on the surface.'), nl.

describe(asteroid) :-
        installed(shields),
        write('You have arrived at the asteroid field.  With your new shields'), nl,
        write('installed, your ship should have no trouble navigating through.'), nl.

describe(asteroid) :-
        write('You have arrived at the asteroid field.  The dense asteroid field presents'), nl,
        write('grave danger for any ship entering without protection.'), nl.

describe(giant) :-
        write('The Gas Giant fills your entire viewport.  Several small, rocky moons orbit'), nl, 
        write('the massive planet.'), nl.

describe(ice) :-
        write('The Ice Planet is unsurprisingly made entirely of ice.  The brochure made it'), nl,
        write('sound much more interesting.  But it''s really just ice.  Lots of ice.'), nl.

describe(derelect) :-
        write('Upon exiting the gate you find yourself in deep space.  Before you is an'), nl,
        write('ancient-looking spacecraft that looks like nothing you''ve ever seen before.'), nl,
        write('The ship appears to be completely powered down, drifting in space.'), nl.

/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('a. b. c.           -- select coordinates for a ftl jump.'), nl,
        write('beam(Object).      -- beam an object into your cargo hold.'), nl,
        write('buy(Object).       -- if you are at a shop, purchase the item.'), nl,    
        write('browse.            -- see the inventory of the shop at the current location'), nl,   
        write('install(Object).   -- install an object on your ship.'), nl,
        write('use(Object).       -- activate an object installed on your ship.'), nl,
        write('look.              -- use your visual scanners (that means eyes).'), nl,
        write('scan.              -- use your actual scanners to get more information.'), nl,
        write('inventory.         -- see what items and credits you have.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.

/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.

/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        name(Place), nl, nl,
        describe(Place),
        nl,
        list_coordinates(Place),
        nl,!.

/* This rule tells us how to scan a planet */

scan :-
        i_am_at(Place),
        scan_result(Place),
        nl,!.

/* These rules describe our scan results */

scan_result(sun) :-
        write('Scan results show it''s hot.  It may have something to do with the sun.').

scan_result(barren) :- 
        at(ore, barren),
        write('Scanners detect a rich deposit of ore on the surface.').

scan_result(station) :-
        holding(artifact),
        win.

scan_result(station) :-
        write('An automated message plays:'), nl,
        write('"Hello there, space captain!  Do I have an adventure for you!  SpaceCorp'), nl,
        write('is looking to obtain a rare alien artifact and we think you''re the captain'), nl,
        write('for the job!  Bring us the artifact and we''ll reward you handsomely.'), nl,
        write('SpaceCorp promises to use the arfifact for scientific research, not'), nl,
        write('to blow up planets, exterminate entire populations or tear the fabric'), nl,
        write('of space-time.  That''s our guarantee! Happy hunting!"').

scan_result(red) :- 
        at(shields, red),
        holding(ore),
        write('Scanners pick up a message from the research station:'), nl,
        write('"You have the ore!  Send it down and we''ll beam up your'), nl,
        write('payment! <...fshrtt...>"'), nl, nl,
        retract(holding(ore)),
        assert(holding(shields)),
        write('You beam down the '), name(ore), write('.  In return, you recieve '), name(shields), nl.

scan_result(red) :-
        at(shields, red),
        write('A research station on the surface contacts you:'), nl,
        write('"<...fffsssrtt...> Greetings and salutations! You'), nl,
        write('appear to be an adventurous space farer.  We need'), nl,
        write('a rare ore, '), name(ore), write(', for our researrch.  Bring us'), nl,
        write('a sample and we will reward you with our latest'), nl,
        write('invention! <....sssfffft...>"').

scan_result(red) :-
        holding(shields),
        write('The research station is silent.  It appears they are'), nl,
        write('quite occupied with their research.').

scan_result(giant) :- 
        write('A mysterious ring is in orbit around the Gas Giant.'), nl,
        installed(transmitter),
        write('The mysterious transmitter you installed begins to glow... mysteriously'), nl.

scan_result(derelect) :- 
        at(artifact, derelect),
        write('Your sensors are picking up a strange energy signiture'), nl,
        write('from inside the derelect spacecraft.  Could it be the'), nl,
        write('alien artifact you''ve been looking for?').

scan_result(ice) :-
        write('Ice.  Lots of ice.').

scan_result(_) :- 
        write('Scanners detect nothing unusual.').

/* This rule lists all the possible ftl coordinates in your place */

list_coordinates(Place) :-
    path(Place, X, There),
    write(X), write(': jump to '), name(There), nl,
    fail.

list_coordinates(_).

/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), name(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules describe how we browse what is for sale */

browse :-
    i_am_at(Place),
    shop(Place),
    credits(C),
    write('Available Credits: '), write(C), nl, nl,
    write('The following items are available for purchase:'), nl, nl,
    at(X, Place),
    sale(X, Price),
    name(X), write(' <'), write(X), write('>'), write(' - '), write(Price), write(' credits'), nl,
    fail, !.

browse :-
    i_am_at(Place),
    shop(Place),
    at(X, Place),
    sale(X, Price),
    Price > 0,
    !.

browse :-
    i_am_at(Place),
    shop(Place),
    write('There is nothing for sale.'), nl.

browse :-
    write('There isn''t a shop here'), nl.

/* These rules describe how to see what is in your inventory */

inventory :-
    write('Credits:'), nl,
    credits(C),
    write(C), nl, nl,
    write('Items in Cargo Hold:'), nl,
    holding(X),
    name(X), write(' <'), write(X), write('> '), nl,
    installed(X), write('(installed)'),nl,
    fail,!.

inventory.

/* These rules describe how to pick up an object. */

beam(shields) :-
        write('You can''t do that'), nl, !.

beam(X) :-
        sale(X, Price),
        Price > 0,
        write('The Ethics-o-tron filter on your transporter prevents you'), nl,
        write('from stealing that object.'),
        nl,!.

beam(X) :-
        holding(X),
        write('You beam the item from your cargo hold to your cargo hold.'), nl,
        write('Brilliant work, Scotty'),
        nl,!.

beam(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('Recieved '), name(X),
        nl,!.

beam(_) :-
        write('Your transporter is having difficulty locking on to that object.'),
        nl,!.

/* These rules describe how to buy items. */

buy(X) :-
        i_am_at(Place),
        shop(Place),
        at(X, Place),
        sale(X, Price),
        credits(C),
        C >= Price,
        retract(credits(C)),
        NewC is C-Price,
        assert(credits(NewC)),
        retract(sale(X, Price)),
        retract(at(X, Place)),
        assert(holding(X)),
        write('You have purchased '), name(X), nl,
        browse,!.

buy(X) :-
        i_am_at(Place),
        shop(Place),
        at(X, Place),
        sale(X, Price),
        credits(C),
        C < Price,
        write('You can''t afford that.'), nl,
        browse,!.

buy(X) :-
        i_am_at(Place),
        shop(Place),
        X,
        write('That item isn''t for sale here'), nl,
        browse,!.

buy(_) :-
        write('There isn''t a shop here'), nl.

/* These rules describe how we install equipment */

install(X) :-
        holding(X),
        equipment(X),
        installed(X),
        name(X), write(' is already installed.'), nl,!.

install(X) :-
        holding(X),
        equipment(X),
        assert(installed(X)),
        name(X), write(' has been installed successfully.'), nl,!.

install(X) :-
        holding(X),
        name(X), write(' cannot be installed on your ship.'), nl,!.

install(X) :-
        write('You don''t have '), name(X), nl,!.

install(_) :- 
        write('You don''t have that object'), nl,!.

/* These rules describe how we can use items */

use(shields) :-
    holding(shields),
    installed(shields),
    write('You boost power to your shields.  Good job.'), nl,!.

use(shields) :-
    holding(shields),
    write('You may want to install your shields before using them.'), nl,!.

use(ore) :- 
    holding(ore),
    write('You stare at the ore for an hour waiting for something to happen'), nl,
    write('...........'), nl,
    write('Nothing happens.'), nl,!.

use(phaser) :-
    holding(phaser),
    write('Pew Pew!'), nl,!.

use(ferret) :-
    holding(ferret),
    i_am_at(giant),
    locked(stargate),
    retract(locked(stargate)),
    write('You squeeze the space ferret gently.  Suddenly, the ferret''s eyes'), nl,
    write('begin to glow.  The giant ring in orbit around the planet comes to'), nl,
    write('life, indicating you can travel through.'), nl, nl,
    write('That was totally unexpected.'), nl,
    look,!.

use(transmitter) :-
    holding(transmitter),
    installed(transmitter),
    i_am_at(giant),
    locked(stargate),
    retract(locked(stargate)),
    write('The transmitter begins to rapidly pulsate with a strange, orange glow.'), nl,
    write('Suddenly, all the power is drained from your system.  The lights go out'), nl,
    write('in your cabin for a few seconds.  When the power comes back online, you'), nl,
    write('glance at your scanners.  The giant ring in orbit around the planet has'), nl,
    write('come to life, indicating you can travel through.'), nl,
    look,!.

use(transmitter) :-
    holding(transmitter),
    installed(transmitter),
    write('The transmitter beeps a few times then falls silent.'), nl,!.

use(transmitter) :-
    holding(transmitter),
    write('You may want to try installing that weird transmitter.'), nl,!.

use(X) :-
    holding(X),
    name(X), write(' does nothing.'), nl,!.

use(X) :-
    write('You don''t have '), name(X), nl,!.

use(_) :-
    write('You don''t have that item'), nl,!.

/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

win :-
    nl,
    write('Congratulations!  You have delivered the artifact to SpaceCorp.'), nl,
    write('Upon recieving your reward, you ponder whether to buy property'), nl,
    write('on the Ice Planet or the Barren Planet.  As you consider the pros'), nl,
    write('and cons of both, you recieve a message:'), nl, nl,
    write('Enter the "halt." command to quit.'), nl, nl,
    write('You have no idea what that means, but it sounds like a good idea.'), nl.

/* This rule tells how to die. */

die :-
        finish.

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.

