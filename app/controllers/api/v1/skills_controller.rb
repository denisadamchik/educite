class Api::V1::SkillsController < ApplicationController
  before_action :set_skill, only: %i[show update destroy]

  # GET /skills
  def index
    @skills = Skill.all

    render json: @skills
  end

  # GET /skills/1
  def show
    render json: @skill
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      render json: @skill, status: :created, location: api_v1_skill_url(@skill)
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /skills/1
  def update
    if @skill.update(skill_params)
      render json: @skill
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /skills/1
  def destroy
    @skill.destroy!
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end
