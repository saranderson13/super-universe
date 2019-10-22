# CREATE SEED USERS
users = [
  { alias: "tiny_flamingo", email: "sarah@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski", admin_status: true },
  { alias: "toki_the_bun", email: "toki@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" },
  { alias: "boarsley", email: "cameron@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" },
  { alias: "giant_peep", email: "peep@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" }
]
users.each do |u|
  User.create(u)
end



# CREATE SEED CHARACTERS
characters = [
  { user_id: 1, supername: "Bomb Girl", secret_identity: "Clara Clearwater", dox_code: "Dox Me", char_type: "Villain", alignment: "Chaotic Evil", hp: 100, att: 250, def: 150, dox_code: "dox me" },
  { user_id: 1, supername: "The Nibbler", secret_identity: "Nathan Nettles", char_type: "Villain", alignment: "Chaotic Neutral", hp: 45, att: 205, def: 250, bio: "Likes to nibble on things...very mouselike. Grew up in a broken home infested with mice and came to bond with them as peers. Main motivation: self preservation. Not truely evil, but due to his place in the counterculture of society and being shunned for his unpleasant manerisms and smells, he has mainly operated as villain." },
  { user_id: 1, supername: "Little Leaf", secret_identity: "Lilly Lilliputian", dox_code: "Dox Me", char_type: "Hero", alignment: "Lawful Good", hp: 250, att: 50, def: 200 },
  { user_id: 1, supername: "Super Skeleton", secret_identity: "Benjamin Bones", dox_code: "Dox Me", char_type: "Hero", alignment: "Chaotic Good", hp: 250, att: 150, def: 100, bio: "He's a spooky scary skeleton!" },
  { user_id: 1, supername: "Spinach Man", secret_identity: "Hamlet Obhearst", dox_code: "Dox Me", char_type: "Hero", alignment: "Lawful Good", hp: 150, att: 100, def: 250, bio: "He really wants you to eat your spinach..." },
  { user_id: 1, supername: "Moon Child", secret_identity: "Aurelie Wane", dox_code: "Dox Me", char_type: "Hero", alignment: "Neutral Good", hp: 75, att: 300, def: 125, bio: "Ethereal being of unknown origin. Possesses awesome power, but is moderately fragile." },
  { user_id: 2, supername: "Bucktooth", secret_identity: "Bucky Bridges", dox_code: "Dox Me", char_type: "Hero", alignment: "Neutral Good", hp: 125, att: 175, def: 200, dox_code: "dox me" },
  { user_id: 2, supername: "Balloon Girl", secret_identity: "Bertha Basso", dox_code: "Dox Me", char_type: "Hero", alignment: "Chaotic Good", hp: 300, att: 150, def: 50, dox_code: "dox me" },
  { user_id: 3, supername: "Incognito", secret_identity: "Sohail Whiteley", dox_code: "Dox Me", char_type: "Villain", alignment: "Lawful Evil", hp: 100, att: 75, def: 325, dox_code: "dox me" },
  { user_id: 3, supername: "Captain Galactic Moth", secret_identity: "Leopold Owen", dox_code: "Dox Me", char_type: "Hero", alignment: "Lawful Good", hp: 150, att: 200, def: 150, dox_code: "dox me" },
  { user_id: 4, supername: "Dragon Boy", secret_identity: "Montgomery Blackwell", dox_code: "Dox Me", char_type: "Hero", alignment: "Chaotic Good", hp: 200, att: 150, def: 150, dox_code: "dox me" },
  { user_id: 4, supername: "Amethyst Heart", secret_identity: "Alma Odam", dox_code: "Dox Me", char_type: "Hero", alignment: "Lawful Good", hp: 100, att: 200, def: 200, dox_code: "dox me" },
  { user_id: 4, supername: "The SubWoofer", secret_identity: "Johnny Rex Golden", dox_code: "Dox Me", char_type: "Villain", alignment: "Chaotic Evil", hp: 200, att: 150, def: 150, dox_code: "dox me" }
]
characters.each do |c|
  Character.create(c)
end




# CREATE SEED MOVES
reg_att = [
  { name: "Quick Jab", move_type: "att", base_pts: 15, success_descrip: "was thrown back from the force of the punch!", fail_descrip: "threw up their arms in defense!" },
  { name: "Haymaker", move_type: "att", base_pts: 20, success_descrip: "falls to the ground clutching their cheek!", fail_descrip: "ducked just in time!" },
  { name: "Nose Dive", move_type: "att", base_pts: 20, success_descrip: "covers their face in defense but can do nothing to prevent the collision as their opponent swoops down from above!", fail_descrip: "dives sideways to evade the attack from above!" },
  { name: "Ten-Fisted Pummeling", move_type: "att", base_pts: 20, success_descrip: "cowers as a barrage of ten strong arms start throwing punches!", fail_descrip: "manages to outrun their many-limbed attacker!" },
  { name: "Triple Punch", move_type: "att", base_pts: 20, success_descrip: "is stunned as three syncronized fists collide with their body!", fail_descrip: "blocks all three fists!" },
  { name: "Bite", move_type: "att", base_pts: 15, success_descrip: "recoils in pain as they are bitten!", fail_descrip: "whips their arm out of the way before they can be bitten" },
  { name: "Stinger", move_type: "att", base_pts: 20, success_descrip: "feels a red hot stinging welt appear on their body!", fail_descrip: "jumps out of the way to avoid the laser!" },
  { name: "Surprise Wedgie!", move_type: "att", base_pts: 15, success_descrip: "squeels in pain as they are given a huge wedgie by their invisible foe!", fail_descrip: "slaps an invisible hand away from their underpants!" },
  { name: "Projectile Barrage", move_type: "att", base_pts: 25, success_descrip: "cowers as they are hit with random inanimate objects from all sides!", fail_descrip: "sprints to find cover!" },
  { name: "Stop Hitting Yourself", move_type: "att", base_pts: 20, success_descrip: "finds themselves compelled to punch themselves in the face!", fail_descrip: "resists the urge to punch themselves in sthe face!" },
  { name: "Fireball", move_type: "att", base_pts: 20, success_descrip: "is burned as a scalding ball of fired hits them in the chest!", fail_descrip: "throws themselves to the ground to avoid the fireball!" },
  { name: "Water Jet", move_type: "att", base_pts: 20, success_descrip: "recoils and falls to the ground as a painful jet of water strikes them!", fail_descrip: "dodgest the narrow jet of water!" },
  { name: "Dirt Nap", move_type: "att", base_pts: 25, success_descrip: "is buried under a huge mound of dirt!", fail_descrip: "digs themselves to freedom before they are crushed by the weight of earth on top of them!" },
  { name: "Whirlwind", move_type: "att", base_pts: 20, success_descrip: "is knocked off their feet and falls hard to the ground!", fail_descrip: "stands their ground!" },
  { name: "Blinding Light", move_type: "att", base_pts: 20, success_descrip: "is temporarily blinded by a bright flash of light!", fail_descrip: "shields their eyes from the intense light!" },
  { name: "Pitch Blackness", move_type: "att", base_pts: 20, success_descrip: "trips and falls as darkness surrounds them!", fail_descrip: "remains still until the darkness lifts!" },
  { name: "Makeshift Bullet", move_type: "att", base_pts: 20, success_descrip: "is hit hard by the nearest metal object!", fail_descrip: "dodges the flying projectile!" },
  { name: "Crystal Spike Field", move_type: "att", base_pts: 25, success_descrip: "hops up and down, as their feet are stabbed by sharp crystals sprouting from the ground!", fail_descrip: "runs away from the crystals that pop up beneath their feet!" },
  { name: "Static Shock", move_type: "att", base_pts: 20, success_descrip: "is shocked as a quick jolt of electricity races through their body!", fail_descrip: "finds a way to ground themselves!" },
  { name: "Hand from Below", move_type: "att", base_pts: 20, success_descrip: "screams as a hand reaches out of the earth and latches to their leg!", fail_descrip: "kicks the boney hand as it clutches for them from the earth!" },
  { name: "Cat Familiar", move_type: "att", base_pts: 20, success_descrip: "is scratched all over by an angry cat!", fail_descrip: "manages to throw the cat away from them!" },
  { name: "Vertigo Illusion", move_type: "att", base_pts: 20, success_descrip: "becomes incredibly dizzy as it seems that the sky and earth have switched places!", fail_descrip: "mainatins their grip on reality!" },
  { name: "Posessed", move_type: "att", base_pts: 25, success_descrip: "is invaded by a spirit and feels as if they are being ripped apart from the inside!", fail_descrip: "fights off the spirit through sheer force of will!" },
  { name: "Shockling Rune Field", move_type: "att", base_pts: 25, success_descrip: "finds themselves surrounded by tiny unavoidable runes and gets shocked several times!", fail_descrip: "deftly hops out of the minefield of tiny runes, avoiding the shocks!" }
]
reg_att.each do |m|
  Move.create(m)
end

pwr_att = [
  { name: "Speed Tackle", move_type: "pwr", base_pts: 45, success_descrip: "has their feet knocked from under them and falls to the ground!", fail_descrip: "quickly jumped out of the way!" },
  { name: "Suplex", move_type: "pwr", base_pts: 50, success_descrip: "is lifted over their opponent's head and slammed mercilessly onto their back.", fail_descrip: "evades their opponent's attempt to grab them" },
  { name: "Death Drop", move_type: "pwr", base_pts: 50, success_descrip: "screams and flails wildly as they are dropped from 60 feet in the air!", fail_descrip: "clutches to their opponent until they are forced to land!" },
  { name: "Octopus Hold", move_type: "pwr", base_pts: 45, success_descrip: "feels their breath slipping away as they are bodily strangled by their opponent!", fail_descrip: "somehow squirms free!" },
  { name: "Dogpile", move_type: "pwr", base_pts: 45, success_descrip: "finds themselves buried under a pile of identical bodies!", fail_descrip: "wriggles out from under the mound unscathed!" },
  { name: "Chomp", move_type: "pwr", base_pts: 45, success_descrip: "howls in pain as their opponent's jaw lock around their shoulder!", fail_descrip: "pushes their opponent away before they can lock their jaws onto them!" },
  { name: "Hyper Beam", move_type: "pwr", base_pts: 45, success_descrip: "feels angry burns start to appear all over their body!", fail_descrip: "ducks to avoid the beam!" },
  { name: "Surprise Roundhouse", move_type: "pwr", base_pts: 45, success_descrip: "is knocked sideways to the ground as something hard an unseen collides with their cheek!", fail_descrip: "feels a whoosh of air as something swings within inches of their face!" },
  { name: "Throw a Whole Ass Tree", move_type: "pwr", base_pts: 55, success_descrip: "is crushed under a whole ass tree!", fail_descrip: "sprints sideways to avoid a whole ass tree barrelling towards them!" },
  { name: "Deadly Suggestion", move_type: "pwr", base_pts: 55, success_descrip: "starts feeling compelled to throw themselves off of the nearest tall structure...can't help but start to walk towards it!", fail_descrip: "has the mental fortitude to fight off the suggestion!" },
  { name: "Wall of Fire", move_type: "pwr", base_pts: 55, success_descrip: "is scalded as an unavoidable wall of flames rushes towards them!", fail_descrip: "cowers behind a rock and is protected from the flames!" },
  { name: "Tsunami", move_type: "pwr", base_pts: 55, success_descrip: "gasps for air as they try to keep their head above water!", fail_descrip: "climbs to high ground just in time to avoid the wall of water!" },
  { name: "Rockslide", move_type: "pwr", base_pts: 55, success_descrip: "is crushed beneath a pile of falling boulders!", fail_descrip: "outruns the mountainside that crumbles behind them!" },
  { name: "Tornado", move_type: "pwr", base_pts: 55, success_descrip: "is spun around and launched into the air, landing several miles away!", fail_descrip: "somehow holds their ground!" },
  { name: "Sun Beam", move_type: "pwr", base_pts: 55, success_descrip: "is scalded and cowers as the sun seems to be focussed on them through a magnifying glass!", fail_descrip: "runs for cover to find shade as the sun beats down on them!" },
  { name: "Strangling Darkness", move_type: "pwr", base_pts: 55, success_descrip: "is confused and gasps for breath as a thick darkness decends, pushing all of the air from their lungs!", fail_descrip: "draws within themself to focus on their breath and ride out the wave of darkness!" },
  { name: "Shrapnel Storm", move_type: "pwr", base_pts: 55, success_descrip: "covers their face as tiny pieces of metal fly at them from every direction!", fail_descrip: "dances around wildy, and miraculously only receives a few scrapes from the flying metal!" },
  { name: "Negative Energy", move_type: "pwr", base_pts: 55, success_descrip: "is consumed by negativity as their vitality is drained!", fail_descrip: "finds the power within themselves to fight off the overwhelming negativity!" },
  { name: "Lightning Storm", move_type: "pwr", base_pts: 55, success_descrip: "feels their whole body electrified with current as they're struck by one of the many bolts of lightning leaping from the sky around them!", fail_descrip: "somehow lucks out and avoids being hit as lightning pummels the ground all around them!" },
  { name: "Undead Horde", move_type: "pwr", base_pts: 65, success_descrip: "is paralyzed by terror as they are vicously attacked by the summoned undead!", fail_descrip: "evades the slow clumsy zombies!" },
  { name: "Wolf Familiar", move_type: "pwr", base_pts: 45, success_descrip: "falls to the ground as a wolf tackles them!", fail_descrip: "wrestles the wolf into submission!" },
  { name: "1,000 Knives Illusion", move_type: "pwr", base_pts: 55, success_descrip: "is baffled as they feel thousands of invisible knives pierce their body! They know the knives aren't there but the pain is real!", fail_descrip: "stays focussed on their breath and doesn't succumb to the illusion!" },
  { name: "Ghostly Body Invasion", move_type: "pwr", base_pts: 60, success_descrip: "falls to the ground shaking and shivering as hundreds of spirits fly through their body!", fail_descrip: "finds the will to withstand the bonechilling cold!" },
  { name: "Fire Rune", move_type: "pwr", base_pts: 45, success_descrip: "accidentally steps backwards onto the rune and is singed from head to toe!", fail_descrip: "deftly hops over the rune!" }
]
pwr_att.each do |m|
  Move.create(m)
end

# CREATE SEED POWERS
powers = [
  { name: "Super Speed", pwr_type: "Physical Enhancement" },
  { name: "Super Strength", pwr_type: "Physical Enhancement" },
  { name: "Flight", pwr_type: "Physical Enhancement"},
  { name: "Extra Limb Generation", pwr_type: "Physical Enhancement"},
  { name: "Replication", pwr_type: "Physical Enhancement"},
  { name: "Fang Generation", pwr_type: "Physical Enhancement"},
  { name: "Laser Eyes", pwr_type: "Physical Enhancement"},
  { name: "Invisibility", pwr_type: "Physical Enhancement"},
  { name: "Telekinesis", pwr_type: "Mental Enhancement" },
  { name: "Hypnosis", pwr_type: "Mental Enhancement" },
  { name: "Fire Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Water Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Earth Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Air Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Light Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Shadow Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Metal Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Crystal Manipulation", pwr_type: "Elemental Mastery" },
  { name: "Electricity Manipuation", pwr_type: "Elemental Mastery"},
  { name: "Necromancy", pwr_type: "Magical Ability" },
  { name: "Familiar Summoning", pwr_type: "Magical Ability" },
  { name: "Illusion Magic", pwr_type: "Magical Ability" },
  { name: "Spirit Summoning", pwr_type: "Magical Ability" },
  { name: "Rune Drawing", pwr_type: "Magical Ability" }
]
powers.map do |p|
  Power.create(p)
end




# ASSIGN MOVES TO POWERS
Power.all.each_with_index do |power, index|
  id = index + 1
  power.add_move(Move.find(id))
  power.add_move(Move.find(id + 24))
  power.save
end




# ASSIGN SEED POWERS TO SEED CHARACTERS
# Bomb Girl
Character.find(1).powers << Power.find(11)
Character.find(1).powers << Power.find(15)
Character.find(1).powers << Power.find(17)

# The Nibbler
Character.find(2).powers << Power.find(6)
Character.find(2).powers << Power.find(21)

# Little Leaf
Character.find(3).powers << Power.find(13)
Character.find(3).powers << Power.find(23)

# Super Skeleton
Character.find(4).powers << Power.find(20)
Character.find(4).powers << Power.find(22)
Character.find(4).powers << Power.find(23)

# Spinach Man
Character.find(5).powers << Power.find(9)
Character.find(5).powers << Power.find(1)
Character.find(5).powers << Power.find(2)

# Moon Child
Character.find(6).powers << Power.find(16)
Character.find(6).powers << Power.find(18)
Character.find(6).powers << Power.find(21)

# Bucktooth
Character.find(7).powers << Power.find(6)
Character.find(7).powers << Power.find(1)

# Balloon Girl
Character.find(8).powers << Power.find(3)
Character.find(8).powers << Power.find(14)

# Incognito
Character.find(9).powers << Power.find(8)
Character.find(9).powers << Power.find(10)
Character.find(9).powers << Power.find(22)

# Captain Galactic Moth
Character.find(10).powers << Power.find(3)
Character.find(10).powers << Power.find(15)
Character.find(10).powers << Power.find(19)

# Dragon Boy
Character.find(11).powers << Power.find(11)
Character.find(11).powers << Power.find(2)
Character.find(11).powers << Power.find(7)

# Amethyst Heart
Character.find(12).powers << Power.find(18)
Character.find(12).powers << Power.find(24)
Character.find(12).powers << Power.find(15)

# The SubWoofer
Character.find(13).powers << Power.find(6)
Character.find(13).powers << Power.find(4)
Character.find(13).powers << Power.find(2)
