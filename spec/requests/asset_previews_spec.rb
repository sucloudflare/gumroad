# frozen_string_literal: true

require "spec_helper"

describe "Asset Previews", type: :request do
  let(:seller) { create(:named_seller) }
  let(:product) { create(:product, user: seller) }

  before { login_as seller }

  describe "POST /links/:link_id/asset_previews/batch" do
    context "when signed_blob_ids are valid" do
      it "returns success with asset previews" do
        post batch_link_asset_previews_path(product.unique_permalink),
          params: { signed_blob_ids: [] },
          as: :json

        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        expect(json["success"]).to be(true)
        expect(json["asset_previews"]).to be_an(Array)
      end
    end

    context "when signed_blob_ids param is missing" do
      it "returns a bad request error" do
        post batch_link_asset_previews_path(product.unique_permalink),
          params: {},
          as: :json

        expect(response.status).to eq(400)
      end
    end

    context "when not logged in" do
      before { logout }

      it "redirects to login" do
        post batch_link_asset_previews_path(product.unique_permalink),
          params: { signed_blob_ids: [] },
          as: :json

        expect(response.status).to eq(302)
      end
    end
  end
end
