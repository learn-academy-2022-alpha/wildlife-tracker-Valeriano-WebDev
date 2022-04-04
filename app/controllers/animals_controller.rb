class AnimalsController < ApplicationController
  def index
    animals = Animal.all
    render json: animals, include: [:sightings]
  end
/-------------------------------------------------------------------------------------------------------/
  def create
    animal = Animal.create(animal_params)
    if animal.valid?
      render json: animal
    else
      render json: animal.errors
    end
  end
  /-------------------------------------------------------------------------------------------------------/
  def show
    animal = Animal.find(params[:id])
    render json: animal, include: [:sightings]
  end
/-------------------------------------------------------------------------------------------------------/
  def update
    animal = Animal.find(params[:id])
    animal.update(animal_params)
    if animal.valid?
      render json: animal
    else
      render json: animal.errors
    end
  end
/-------------------------------------------------------------------------------------------------------/
  def destroy
    animals = Animal.find(params[:id])
    if animals.destroy
      render json: animals
    else
      render json: animals.errors
    end
  end
/-------------------------------------------------------------------------------------------------------/
  private
  def animal_params
    params.require(:animal).permit(:common_name, :latin_name, :kingdom)
  end
end
