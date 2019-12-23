# frozen_string_literal: true

module Decidim
  module UnedEngine
    module CareProposalsHelper
      def care_proposals
        [
          {
            title: "Cautela 1",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 1")
          },
          {
            title: "Cautela 2",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 2")
          },
          {
            title: "Cautela 3",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 3")
          },
          {
            title: "Cautela 4",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 4")
          },
          {
            title: "Cautela 5",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 5")
          },
          {
            title: "Cautela 6",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 6")
          },
          {
            title: "Cautela 7",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 7")
          },
          {
            title: "Cautela 8",
            description: "Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos (primum nil nocere) y cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria, particularmente del de los colectivos más vulnerables.",
            proposal: find_proposal("Cautela 8")
          }
        ].select { |care_proposal| care_proposal[:proposal].present? }
      end

      def care_proposal_vote_path(proposal)
        decidim_proposals.proposal_proposal_vote_path(proposal_id: proposal, from_proposals_list: false)
      end

      def care_proposal_vote_button_classes
        "uned-poll-slider-participa-button-right expanded button--sc"
      end

      private

      def find_proposal(text)
        process = Decidim::ParticipatoryProcess.find_by(organization: current_organization)
        component = Decidim::Component.where(participatory_space: process)

        Decidim::Proposals::Proposal.where(component: component).find_by("title ilike ?", "%#{text}%")
      end
    end
  end
end
