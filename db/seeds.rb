users = [
  { alias: "tiny_flamingo", email: "sarah@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski", admin_status: true },
  { alias: "toki_the_bun", email: "toki@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" },
  { alias: "boarsley", email: "cameron@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" },
  { alias: "giant_peep", email: "peep@tokilily.com", password: "sto0fski", password_confirmation: "sto0fski" }
]
users.each do |u|
  User.create(u)
end




characters = [
  { user_id: 1, supername: "Bomb Girl", secret_identity: "Clara Clearwater", char_type: "Villain", alignment: "Chaotic Evil", hp: 100, att: 250, def: 150, dox_code: "dox me" },
  { user_id: 1, supername: "The Nibbler", secret_identity: "Nathan Nettles", char_type: "Villain", alignment: "Chaotic Neutral", hp: 45, att: 205, def: 250, bio: "Likes to nibble on things...very mouselike. Grew up in a broken home infested with mice and came to bond with them as peers. Main motivation: self preservation. Not truely evil, but due to his place in the counterculture of society and being shunned for his unpleasant manerisms and smells, he has mainly operated as villain." },
  { user_id: 2, supername: "Bucktooth", secret_identity: "Bucky Bridges", char_type: "Hero", alignment: "Neutral Good", hp: 125, att: 175, def: 200, dox_code: "dox me" },
  { user_id: 2, supername: "Balloon Girl", secret_identity: "Bertha Basso", char_type: "Hero", alignment: "Chaotic Good", hp: 300, att: 150, def: 50, dox_code: "dox me" },
  { user_id: 3, supername: "Incognito", secret_identity: "Sohail Whiteley", char_type: "Villain", alignment: "Lawful Evil", hp: 100, att: 75, def: 325, dox_code: "dox me" },
  { user_id: 3, supername: "Captain Galactic Moth", secret_identity: "Leopold Owen", char_type: "Hero", alignment: "Lawful Good", hp: 150, att: 200, def: 150, dox_code: "dox me" },
  { user_id: 4, supername: "Dragon Boy", secret_identity: "Montgomery Blackwell", char_type: "Hero", alignment: "Chaotic Good", hp: 200, att: 150, def: 150, dox_code: "dox me" },
  { user_id: 4, supername: "Amethyst Heart", secret_identity: "Alma Odam", char_type: "Hero", alignment: "Lawful Good", hp: 100, att: 200, def: 200, dox_code: "dox me" }
]
characters.each do |c|
  Character.create(c)
end
