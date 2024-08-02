require 'swagger_helper'

RSpec.describe 'Authors API', type: :request do
  path '/authors' do
    get('list authors') do
      tags 'Authors'
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

    post('create author') do
      tags 'Authors'
      consumes 'application/json'
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'successful') do
        let(:author) { { name: 'John Doe' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('John Doe')
        end
      end

      response(422, 'invalid request') do
        let(:author) { { name: '' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('can\'t be blank')
        end
      end
    end
  end

  path '/authors/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show author') do
      tags 'Authors'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        }

        let(:id) { Author.create(name: 'John Doe').id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('John Doe')
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update author') do
      tags 'Authors'
      consumes 'application/json'
      parameter name: :author, in: :body, schema: {
        type: :object, properties: {
          name: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { Author.create(name: 'John Doe').id }
        let(:author) { { name: 'Jane Doe' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Jane Doe')
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:author) { { name: 'Jane Doe' } }

        run_test!
      end
    end

    delete('delete author') do
      tags 'Authors'

      response(204, 'no content') do
        let(:id) { Author.create(name: 'John Doe').id }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
