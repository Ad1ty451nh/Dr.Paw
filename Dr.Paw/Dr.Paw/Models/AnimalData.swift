//
//  AnimalData.swift
//  Dr.Paw
//
//  Real starter data for all 17 requested animals. Review/adjust
//  wording as you like — this is meant to get the library fully
//  populated and working, not to be the final word on animal care.
//

import Foundation

enum AnimalData {
    static let all: [Animal] = [

        // MARK: Dogs
        Animal(
            name: "Labrador",
            species: "Labrador Retriever",
            category: .dog,
            imageName: "Labrador",
            idealEnvironment: "Active family home with yard space to run and swim in; not suited to being left alone for long stretches.",
            bestFood: "High-quality protein-based kibble, lean meats like chicken, occasional fruits like apples and blueberries.",
            foodToAvoid: "Chocolate, grapes/raisins, onions, garlic, xylitol (sugar-free gum), macadamia nuts.",
            specificTip: "Prone to obesity — measure meals instead of free-feeding, and keep up daily exercise."
        ),
        Animal(
            name: "Pug",
            species: "Pug",
            category: .dog,
            imageName: "Pug",
            idealEnvironment: "Apartment-friendly, calm indoor environment with air conditioning; sensitive to heat and humidity due to its flat face.",
            bestFood: "Small-breed formulated kibble, portion-controlled meals, lean proteins.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty or fried table scraps.",
            specificTip: "Avoid strenuous exercise in heat — pugs overheat and struggle to breathe easily because of their short snouts."
        ),
        Animal(
            name: "Golden Retriever",
            species: "Golden Retriever",
            category: .dog,
            imageName: "Golden Retriever",
            idealEnvironment: "Spacious home with a yard, thrives around families and other pets, needs regular mental and physical stimulation.",
            bestFood: "High-protein diet with omega-3s (fish oil) for coat health, lean meats, vegetables.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, high-fat table scraps.",
            specificTip: "The breed has an above-average cancer risk — regular vet checkups and monitoring for new lumps matters more than usual."
        ),
        Animal(
            name: "German Shepherd",
            species: "German Shepherd Dog",
            category: .dog,
            imageName: "German Shepherd",
            idealEnvironment: "Needs space to move and strong mental stimulation — a working breed that does best with training, tasks, or a job to do.",
            bestFood: "High-protein large-breed formula with joint-supporting nutrients like glucosamine.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty foods.",
            specificTip: "Prone to hip and elbow dysplasia — avoid excessive jumping or stairs while the joints are still developing as a puppy."
        ),
        Animal(
            name: "Rottweiler",
            species: "Rottweiler",
            category: .dog,
            imageName: "Rottweiler",
            idealEnvironment: "Needs firm, consistent training and early socialization; does best with active, experienced owners.",
            bestFood: "Large-breed formulated food with controlled calcium levels while growing, to support healthy joint development.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty scraps.",
            specificTip: "Deep-chested breed — feed two smaller meals a day instead of one large one, and avoid vigorous exercise right after eating (bloat risk)."
        ),

        // MARK: Cats
        Animal(
            name: "Persian White",
            species: "Persian Cat",
            category: .cat,
            imageName: "Persian White",
            idealEnvironment: "Indoor-only, calm and quiet home, kept away from heat since their long coat traps warmth.",
            bestFood: "High-quality wet food for hydration, plus a hairball-control formula.",
            foodToAvoid: "Milk/dairy, onions, garlic, chocolate, raw dough.",
            specificTip: "Daily brushing is essential — the long coat mats quickly, and flat faces make them prone to tear staining and hairballs."
        ),
        Animal(
            name: "British Shorthair",
            species: "British Shorthair",
            category: .cat,
            imageName: "British Shorthair",
            idealEnvironment: "Calm indoor cat, low-energy, tolerates being alone better than most breeds, enjoys cozy resting spots.",
            bestFood: "Portion-controlled dry/wet food mix — calorie control matters for this breed.",
            foodToAvoid: "Milk, onions, garlic, chocolate, grapes.",
            specificTip: "Naturally low-activity — encourage regular play with toys to prevent the weight gain this breed is prone to."
        ),
        Animal(
            name: "Ragdoll",
            species: "Ragdoll Cat",
            category: .cat,
            imageName: "Ragdoll",
            idealEnvironment: "Indoor-only, calm household — known for being docile and going limp when held, hence the name.",
            bestFood: "High-protein wet/dry food mix; prone to weight gain so portion control matters.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Very trusting and low self-defense instinct — best kept strictly indoors, away from outdoor hazards."
        ),
        Animal(
            name: "Maine Coon",
            species: "Maine Coon Cat",
            category: .cat,
            imageName: "Maine Coon",
            idealEnvironment: "Adaptable to indoor or supervised outdoor space; large breed that appreciates room to roam.",
            bestFood: "High-protein diet suited to a larger-than-average body frame; large-breed cat formula if available.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Prone to hypertrophic cardiomyopathy (a heart condition) — regular vet checkups are especially important for this breed."
        ),

        // MARK: Birds
        Animal(
            name: "Pigeon",
            species: "Rock Pigeon",
            category: .bird,
            imageName: "Pigeon",
            idealEnvironment: "Open, ventilated loft or coop with room to fly; social birds best kept in pairs or groups.",
            bestFood: "Grain and seed mix (corn, wheat, peas) with added grit to aid digestion.",
            foodToAvoid: "Avocado, chocolate, salty foods, moldy grain.",
            specificTip: "Pigeons mate for life and are highly social — isolating one long-term causes real stress."
        ),
        Animal(
            name: "Parrot",
            species: "Parrot",
            category: .bird,
            imageName: "Parrot",
            idealEnvironment: "Spacious cage with room to spread its wings, plus toys or puzzles for mental stimulation and daily social interaction.",
            bestFood: "Pellet-based diet supplemented with fresh vegetables and fruits.",
            foodToAvoid: "Avocado, chocolate, caffeine, salty or sugary snacks, alcohol.",
            specificTip: "Highly intelligent and prone to anxiety or feather-plucking from boredom — rotate toys and give daily out-of-cage time."
        ),
        Animal(
            name: "Sparrow",
            species: "House Sparrow",
            category: .bird,
            imageName: "Sparrow",
            idealEnvironment: "A wild, free-flying bird best not kept caged; if rehabilitating an injured one, needs a quiet, warm, sheltered space.",
            bestFood: "Small seeds and grains, plus insects — especially important for feeding chicks.",
            foodToAvoid: "Bread (low nutritional value), salty foods, avocado.",
            specificTip: "Sparrows are becoming rare in cities — a small nest box or shallow water dish can genuinely help local populations."
        ),

        // MARK: Farm Animals
        Animal(
            name: "Cow",
            species: "Domestic Cattle",
            category: .farmAnimal,
            imageName: "Cow",
            idealEnvironment: "Open pasture with grazing space, shelter from extreme heat or cold, and constant access to clean water.",
            bestFood: "Grass, hay, and silage, with a balanced grain supplement for dairy cows.",
            foodToAvoid: "Moldy or spoiled feed, chocolate, avocado, large amounts of grain (bloat/acidosis risk).",
            specificTip: "Cows are herd animals and get visibly stressed when isolated — keeping at least one companion animal nearby helps their wellbeing."
        ),
        Animal(
            name: "Buffalo",
            species: "Water Buffalo",
            category: .farmAnimal,
            imageName: "Buffalo",
            idealEnvironment: "Access to water for wallowing to regulate body temperature, open grazing land, and shade.",
            bestFood: "Grass, hay, and fodder crops, with supplemental grain during milk production.",
            foodToAvoid: "Moldy feed, excessive grain, chocolate.",
            specificTip: "Buffaloes handle heat poorly without water access — regular wallowing or bathing prevents heat stress, especially in summer."
        ),
        Animal(
            name: "Horse",
            species: "Domestic Horse",
            category: .farmAnimal,
            imageName: "Horse",
            idealEnvironment: "Open pasture with room to move, shelter from weather, and herd companionship — horses are social animals.",
            bestFood: "Grass or hay as the base diet, with grain supplements in moderation for working horses.",
            foodToAvoid: "Chocolate, avocado, excess sugary treats, moldy hay (colic risk).",
            specificTip: "Horses can't vomit — overeating grain or spoiled feed can quickly turn into a life-threatening colic, so feed is always carefully measured."
        ),

        // MARK: Rodents
        Animal(
            name: "Hamster",
            species: "Syrian Hamster",
            category: .rodent,
            imageName: "Hamster",
            idealEnvironment: "Solitary housing (most species fight if paired), a spacious cage with bedding for burrowing, away from drafts.",
            bestFood: "Commercial hamster seed/pellet mix with occasional fresh vegetables.",
            foodToAvoid: "Citrus fruits, onion, garlic, chocolate, bitter almonds.",
            specificTip: "Nocturnal by nature — expect activity at night, and avoid disturbing daytime sleep, which stresses them out."
        ),
        Animal(
            name: "Rabbit",
            species: "Domestic Rabbit",
            category: .rodent,
            imageName: "Rabbit",
            idealEnvironment: "Spacious enclosure or a bunny-proofed room with daily hopping/exercise space, kept away from extreme heat.",
            bestFood: "Unlimited timothy hay as the base, plus leafy greens and a small portion of pellets.",
            foodToAvoid: "Iceberg lettuce, sugary treats, avocado, chocolate.",
            specificTip: "A rabbit's teeth grow continuously — constant access to hay wears them down naturally and prevents painful overgrowth."
        ),

        // MARK: Reptiles
        Animal(
            name: "Turtle",
            species: "Turtle",
            category: .reptile,
            imageName: "Turtle",
            idealEnvironment: "Depends on the species — aquatic turtles need a water tank with a basking area and UVB light; land species need a dry enclosure with hiding spots.",
            bestFood: "Varies by species — typically a mix of leafy greens, commercial turtle pellets, and occasional protein like worms for omnivorous types.",
            foodToAvoid: "Dairy products, processed or salty human food, iceberg lettuce (low nutrition).",
            specificTip: "UVB lighting isn't optional — without it, turtles can't metabolize calcium properly and develop serious shell and bone problems."
        )
    ]
}
