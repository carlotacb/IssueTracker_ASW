class IssueIndexSerializer < ActiveModel::Serializer
    attributes :id, :Title, :Description, :Type, :Priority, :Status, :Votes, :Watchers, :created_at, :updated_at, :_links
    
    def _links
        links = {
            self: { href: "/issues/#{object.id}" },
            creator: { href: "/users/#{object.user_id}" },
            assignee: { href: "/users/#{object.assignee_id}" },
        }
    end
    
end