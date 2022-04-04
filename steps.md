**INITIAL SETUP**
$ rails new wildlife_tracker -d postgresql -T
$ cd wildlife_tracker
$ rails db:create
$ bundle add rspec-rails
$ rails generate rspec:install
$ rails server

-------------------------------------------------------------------------------------------------------
**Story: As a developer I can create an animal model in the database. An animal has the following information: common name, 
latin name, kingdom (mammal, insect, etc.)**

$ rails g resource Animal common_name:string, latin_name:string, kingdom:string
$ rails db:migrate
$ rails server

-------------------------------------------------------------------------------------------------------
**Story: As the consumer of the API I can see all the animals in the database.
Hint: Make a few animals using Rails Console**
rails c
Animal.create common_name:"LilReecey", latin_name:"BooBaeBunny", kingdom:"Mammal"
Animal.create common_name:"Brown Kuoala", latin_name:"JoseFini-SiSonus", kingdom:"Mammal"
Animal.create common_name:"Mythical Handsome-Liger", latin_name:"Bocaj onairelav", kingdom:"Unknown"
Animal.create common_name:"Bipedal 1sg Dragon", latin_name:"Omari-Bowendus", kingdom:"Reptile/Bipedal"

-------------------------------------------------------------------------------------------------------
**animals_controller** 
Create index method to view all animals in db

def index
animals = Animal.all
render json: animals
end

**In postman create a request:**
GET http://localhost:3000/animals

-------------------------------------------------------------------------------------------------------
**Story: As the consumer of the API I can create a new animal in the database.**
Create a method create in animals_controller

def create
animal = Animal.create(animal_params)
if animal.valid?
render json:animal
else
render json: animal.errors
end
end

private
def animal_params
params.require(:animal).permit(:common_name, :latin_name, :kingdom)
end

**In Postman --> Body --> Raw**

{
"common_name": "SatoshiHumming-Bird",
"latin_name": "NakamoTtilli",
"kingdom": "Bird",
}
}

** POST: http://localhost:3000/animal **

-------------------------------------------------------------------------------------------------------
**Story: As the consumer of the API I can update an animal in the database.**
Create an update method in animals_controller

**animals_controller**

  def update
  animal = Animal.find(params[:id])
  animal.update(animal_params)
  if animal.valid?
  render json: animal
  else
  render json: animal.errors
  end
  end

{
"animal": {
"common_name": "Nala the lion",
"latin_name": "Feline Fatale",
"kingdom": "mammal"
}
}

**PATCH:  http://localhost:3000/animals/[:id]**

-------------------------------------------------------------------------------------------------------
**Story: As the consumer of the API I can destroy an animal in the database.**

**animals_controller**

def destroy
animals = Animal.find(params[:id])
if animals.destroy
render json: animals
else
render json: animal.errors
end
end

DESTROY: http://localhost:3000/animals/[:id]

-------------------------------------------------------------------------------------------------------
**Story: As the consumer of the API I can create a sighting of an animal with date (use the datetime datatype), a latitude, and a longitude.**
Hint: An animal has_many sightings. (rails g resource Sighting animal_id:integer ...)
Hint: Datetime is written in Rails as “year-month-day hr:min:sec" (“2022-01-28 05:40:30")

rails g resource Sighting animal_id:integer date:datetime latitude:decimal longitude:decimal
** tried adding precision and scale for greater accuracy with longitude/latitude **

rails db:migrate

In order to connect sightings to a specific animal, add associations in model
**sighting.rb**
belongs_to :animal

**animal.rb**
has_many :sightings

**In Rails Console**
lilreecey.sightings.create date:"2022-03-25 05:23:10", latitude:98746, longitude:102938
Animal.third.sightings.create date:"2022-02-11 09:45:00", latitude:98746, longitude:102938

**In Postman**
**POST : http://localhost:3000/sightings/**
{
"sighting": {
"animal_id": "1",
"date": "2022-03-25 05:23:10",
"longitude": "039136",
"latitude": "99485l"
}
"sighting": {
"animal_id": "1",
"date": "2022-03-25 05:23:10",
"longitude": "039136",
"latit
}

{
"sighting": {
"animal_id": "4",
"date": "2022-03-25 05:23:10",
"longitude": "789136",
"latitude": "46985l"
}
}
**GET : http://localhost:3000/sightings/**
(Verify sightings)

-------------------------------------------------------------------------------------------------------
Story: As the consumer of the API I can update an animal sighting in the database.

**sightings_controller**

def update
sighting = Sighting.find(params[:id])
sighting.update(sighting_params)
if sighting.valid?
      render json: sighting
    else
      render json: sighting.errors
    end
end

**POSTMAN:**
**PATCH: http://localhost:3000/sightings/4** 
{
"sighting": {
"animal_id": "4",
"date": "2012-03-25 05:23:10",
"longitude": "789136",
"latitude": "46985l"
}
}

**GET: http://localhost:3000/sightings/**
(verify update)

-------------------------------------------------------------------------------------------------------
Story: As the consumer of the API I can destroy an animal sighting in the database.

**sightings_controller**

def destroy
sighting = Sighting.find(params[:id])
if sighting.destroy
render json: sighting
else
render json: sighting.errors
end
end

**POSTMAN**
**DESTROY: http://localhost:3000/sightings/1** 
**GET: http://localhost:3000/sightings/**
(Verify sighting with id 1 deleted)

-------------------------------------------------------------------------------------------------------
Story: As the consumer of the API, when I view a specific animal, I can also see a list sightings of that animal.
Hint: Checkout the Ruby on Rails API docs on how to include associations.

def index
animals = Animal.all
render json: animals, include: [:sightings]
end



-------------------------------------------------------------------------------------------------------
Story: As the consumer of the API, I can run a report to list all sightings during a given time period.
Hint: Your controller can look like this:
-------------------------------------------------------------------------------------------------------