class Api::V1::CoursesController < ApplicationController
  before_action :set_author, only: %i[index create]
  before_action :set_course, only: %i[show update destroy]

  # GET /authors/:author_id/courses
  def index
    @courses = @author.courses

    render json: @courses, each_serializer: CourseSerializer, include_skills: false
  end

  # GET /courses/1
  def show
    render json: @course, serializer: CourseSerializer
  end

  # POST /authors/:author_id/courses
  def create
    @course = @author.courses.build(course_params)

    if @course.save
      render json: @course,
             status: :created,
             location: api_v1_course_url(@course),
             serializer: CourseSerializer,
             include_skills: false
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      render json: @course, serializer: CourseSerializer
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy!
  end

  private

  def set_author
    @author = Author.find(params[:author_id])
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, skill_ids: [])
  end
end
