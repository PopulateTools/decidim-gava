# frozen_string_literal: true

module Decidim
  module UnedEngine
    module CareProposalsHelper
      def care_proposals
        [
          {
            title: "Cautela 0",
            subtitle: "Del cuidado",
            description: """
            Una voluntad expresa de cuidado guiará en todo momento las actuaciones de la UNED
            respecto al uso de los datos: tendrá cuidado de que no se haga un mal uso de ellos y
            cuidará, a través de ellos, del bienestar de los miembros de la comunidad universitaria,
            particularmente del de los colectivos más vulnerables.
            """,
            proposal: find_proposal("Cautela 0")
          },
          {
            title: "Cautela 1",
            subtitle: "De la responsabilidad",
            description: """
            La UNED asume su responsabilidad en el uso de datos y determinará una autoridad
            reconocible que será responsable del uso legal, ético y eficiente de las tecnologías basadas
            en datos. Además, será necesario fijar quién tiene responsabilidades específicas sobre la
            anonimización de los datos así como su recolección, conservación y administración.
            """,
            proposal: find_proposal("Cautela 1")
          },
          {
            title: "Cautela 2",
            subtitle: "De la transparencia",
            description: """
            La UNED desarrollará políticas institucionales claras con respecto al uso de tecnologías
            basadas en datos masivos. Definirá, registrará y comunicará a la comunidad universitaria
            las fuentes de datos, los propósitos de los análisis, las métricas usadas, quién tiene acceso
            a los análisis, los límites de su uso y cómo se interpretan los datos. Cuando los datos
            estén incompletos o se usen como aproximación a otros no disponibles, se aclarará en qué
            suposiciones se basa dicha aproximación.
            """,
            proposal: find_proposal("Cautela 2")
          },
          {
            title: "Cautela 3",
            subtitle: "Del consentimiento",
            description: """
            El consentimiento de cada miembro de la comunidad universitaria será necesario para
            el uso de sus datos personales. Si el consentimiento se da al inicio de la relación con la
            UNED, será informado con explicaciones detalladas acerca del uso previsto de los datos.
            Cuando los datos se usen para intervenir en las decisiones que afectan a la trayectoria de
            una persona en el seno de la institución o al acceso a sus recursos, será necesario obtener
            consentimiento expreso y específico para esos usos. La UNED establecerá protocolos para
            permitir la revocación del consentimiento.
            """,
            proposal: find_proposal("Cautela 3")
          },
          {
            title: "Cautela 4",
            subtitle: "De la privacidad y el acceso",
            description: """
            El acceso a los datos y a los análisis derivados de ellos estará restringido a quienes tengan
            una causa legítima, que será determinada por la UNED en función del nivel de agregación
            de los datos y las competencias de quienes lo soliciten. Cuando los datos sean anónimos, la
            UNED cuidará de que no sea posible reidentificar a los individuos a partir de los metadatos
            ni por agregación de múltiples fuentes de datos. La UNED tendrá particular cuidado,
            en el caso de que los datos sean cedidos a terceras partes, de que estas se adhieran a las
            cautelas aquí expresadas y a los principios de la institución, evitando particularmente
            usos comerciales.
            """,
            proposal: find_proposal("Cautela 4")
          },
          {
            title: "Cautela 5",
            subtitle: "De la propiedad y el control",
            description: """
            La UNED asume que no es la propietaria de los datos personales recabados, sino solo
            la responsable temporal de su tratamiento. Conforme a las prácticas indicadas por la
            Agencia Española de Protección de Datos en cumplimiento del Reglamento Europeo de
            Protección de Datos, la UNED cuidará de que los miembros de su comunidad tengan la
            posibilidad de corregir, eliminar o añadir contexto a sus datos siempre que sea posible, así
            como la de acceder a los análisis derivados y la de reclamar ante posibles consecuencias
            adversas del uso de tecnologías basadas en datos.
            """,
            proposal: find_proposal("Cautela 5")
          },
          {
            title: "Cautela 6",
            subtitle: "De la validez y la fiabilidad",
            description: """
            Para asegurar que las aplicaciones de tecnologías basadas en datos son válidas y fiables,
            la UNED garantizará que los datos son precisos y representativos de aquello que dicen
            medir. Además, serán mantenidos al día tanto como sea posible. Cuando en el análisis
            se usen encuestas de opinión o se apliquen inferencias estadísticas, la UNED cuidará
            de que la muestra sea suficientemente grande y representativa y de que los resultados
            sean estadísticamente significativos. Todos los algoritmos y métricas utilizados serán
            comprendidos, validados, revisados y mejorados según corresponda por personal cualificado
            """,
            proposal: find_proposal("Cautela 6")
          },
          {
            title: "Cautela 7",
            subtitle: "De los posibles impactos adversos",
            description: """
            La UNED reconoce que cualquier individuo es siempre más que la suma de los datos
            disponibles acerca de ella o él, y que las circunstancias personales no pueden ser descritas
            totalmente por los datos. Así, tomará medidas para evitar que tendencias, promedios,
            categorías o etiquetas produzcan sesgos en la percepción de la institución sobre las
            personas o en su relación con ellas, así como que se refuercen actitudes discriminatorias
            o se incrementen las desigualdades. Además, el impacto de las intervenciones basadas en
            datos sobre los distintos colectivos de la comunidad universitaria será tenido en cuenta,
            particularmente en las necesidades de formación y en la carga de trabajo. En cualquier
            caso, la UNED hará lo que esté en su mano por minimizar los posibles impactos adversos.
            """,
            proposal: find_proposal("Cautela 7")
          },
          {
            title: "Cautela 8",
            subtitle: "De la participación",
            description: """
            Siempre que sea posible, la UNED tratará de involucrar a los distintos colectivos de la
            comunidad universitaria en la aplicación de tecnologías basadas en datos. En particular,
            dadas las relaciones asimétricas de poder en relación con el alumnado, otros colectivos de
            la UNED (profesorado, personal de administración) tratarán a sus miembros como iguales
            en lo relativo a los usos de sus datos, cuidando de que su punto de vista sea tenido en
            cuenta en la toma de decisiones.
            """,
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

        Decidim::Proposals::Proposal.where(component: component)
                                    .where("title ilike ?", "%#{text}%")
                                    .to_a.select(&:official?).first
      end
    end
  end
end
