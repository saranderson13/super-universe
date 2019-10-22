# super-universe

Super Universe is a web application in which you can make superheroes and supervillains and then battle them to the death! (Well...until they get knocked out. They always live to fight another day.)

## Installation

For the moment, to install the application, download the repo and run 'bundle install'. Then migrate the db and seed! This will load up the database with some starting data.

```bash
bundle install

rails db:migrate

rails db:seed
```

## Usage

Start up a rails server and then navigate to your local host.

```bash
rails s
```

Once there, you can create an account, or log in with your Google account, and start making characters, but clicking the "New Char" button at the top of the screen! Once you create a character, go check out the powers to add a few. Click on any power, and characters that are eligible to have that power will be listed as options. (All characters are eligible for any power as long as they haven't reached the limit of 3.)

To Battle, visit other character's profiles and browse through their characters! If your character is eligible to battle them they'll be listed in the dropdown menu.

Gameplay: Works as your typical turn based battling game. You choose your attack - your opponent will either take the damage or dodge it, and then will attack with a move of your own. Your character may dodge that, or they'll take the hit. The battle rages on until only one character is left standing.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)
