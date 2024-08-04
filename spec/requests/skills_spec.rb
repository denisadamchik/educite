require 'swagger_helper'

RSpec.describe 'Skills API', type: :request do
  path '/api/v1/skills' do
    get('list skills') do
      tags 'Skills'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          }
        }

        run_test!
      end
    end

    post('create skill') do
      tags 'Skills'
      consumes 'application/json'
      parameter name: :skill, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'successful') do
        let(:skill) { { name: 'Ruby' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Ruby')
        end
      end

      response(422, 'invalid request') do
        let(:skill) { { name: '' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to include("can't be blank")
        end
      end
    end
  end

  path '/api/v1/skills/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID of the skill'

    get('show skill') do
      tags 'Skills'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        }

        let(:id) { Skill.create(name: 'JavaScript').id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('JavaScript')
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update skill') do
      tags 'Skills'
      consumes 'application/json'
      parameter name: :skill, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { Skill.create(name: 'Python').id }
        let(:skill) { { name: 'Ruby' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Ruby')
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:skill) { { name: 'Ruby' } }

        run_test!
      end
    end

    delete('delete skill') do
      tags 'Skills'

      response(204, 'no content') do
        let(:id) { Skill.create(name: 'CSS').id }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
