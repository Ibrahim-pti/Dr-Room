<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AnatomyController extends Controller
{
    /**
     * Get list of anatomical body systems (GetBodySmart style)
     */
    public function systems(): JsonResponse
    {
        $systems = [
            [
                'id' => 'muscular',
                'name' => 'Muscular System',
                'latin' => 'Systema Musculare',
                'icon' => 'fitness_center',
                'color' => '#6366F1',
                'description' => 'Skeletal, cardiac, and smooth muscle tissue responsible for voluntary motor articulation, posture, and circulatory pumping.',
                'subcategories' => ['Head & Neck Muscles', 'Torso & Abdomen Muscles', 'Upper Extremity Muscles', 'Lower Extremity Muscles']
            ],
            [
                'id' => 'nervous',
                'name' => 'Nervous System',
                'latin' => 'Systema Nervosum',
                'icon' => 'psychology',
                'color' => '#F59E0B',
                'description' => 'Central brain & spinal cord network coordinating 86 billion neurons for sensory perception and autonomic regulation.',
                'subcategories' => ['Central Nervous System (CNS)', 'Peripheral Nervous System (PNS)', 'Autonomic Nervous System (ANS)']
            ],
            [
                'id' => 'circulatory',
                'name' => 'Cardiovascular System',
                'latin' => 'Systema Cardiovasculare',
                'icon' => 'favorite',
                'color' => '#EF4444',
                'description' => 'Four-chambered heart and 100,000 km arterial/venous network circulating oxygenated blood.',
                'subcategories' => ['Coronary Circulation', 'Systemic Arteries', 'Venous Return', 'Pulmonary Circuit']
            ],
            [
                'id' => 'respiratory',
                'name' => 'Respiratory System',
                'latin' => 'Systema Respiratorium',
                'icon' => 'air',
                'color' => '#EC4899',
                'description' => 'Lungs and bronchial tree providing alveolar gas exchange across 300 million micro-sacs.',
                'subcategories' => ['Upper Airway (Larynx/Pharynx)', 'Bronchial Tree', 'Alveolar Membrane']
            ],
            [
                'id' => 'digestive',
                'name' => 'Digestive System',
                'latin' => 'Systema Digestorium',
                'icon' => 'restaurant',
                'color' => '#F97316',
                'description' => 'Gastrointestinal tract digesting nutrients via gastric HCl acid, enzymes, and enteric nervous feedback.',
                'subcategories' => ['Stomach & Gastric Cavity', 'Small Intestine (Duodenum/Jejunum)', 'Large Intestine & Colon']
            ],
            [
                'id' => 'hepatic',
                'name' => 'Hepato-Biliary System',
                'latin' => 'Hepar & Vesica Biliaris',
                'icon' => 'opacity',
                'color' => '#D97706',
                'description' => 'Liver and gall bladder performing 500+ metabolic filtration, detoxification, and bile secretion pathways.',
                'subcategories' => ['Hepatic Lobules', 'Biliary Duct Tree', 'Gallbladder Storage']
            ],
            [
                'id' => 'renal',
                'name' => 'Renal & Excretory System',
                'latin' => 'Systema Uropoeticum',
                'icon' => 'water_drop',
                'color' => '#3B82F6',
                'description' => 'Kidneys filtering 180 liters of blood daily via 2 million nephron units for fluid and electrolyte balance.',
                'subcategories' => ['Renal Cortex & Glomerulus', 'Nephron Tubules', 'Ureters & Bladder']
            ],
            [
                'id' => 'endocrine',
                'name' => 'Endocrine System',
                'latin' => 'Systema Endocrinum',
                'icon' => 'hub',
                'color' => '#A855F7',
                'description' => 'Pituitary, thyroid, adrenal, and pancreatic glands secreting systemic metabolic regulatory hormones.',
                'subcategories' => ['Thyroid Gland', 'Adrenal Cortex', 'Pancreatic Islets']
            ],
            [
                'id' => 'skeletal',
                'name' => 'Skeletal System',
                'latin' => 'Systema Sceletale',
                'icon' => 'accessibility_new',
                'color' => '#64748B',
                'description' => '206 bones, cartilages, and ligaments supporting body structure, marrow hematopoiesis, and mineral storage.',
                'subcategories' => ['Axial Skeleton', 'Appendicular Skeleton', 'Synovial Joints']
            ]
        ];

        return response()->json([
            'status' => 'success',
            'message' => 'GetBodySmart Medical Systems fetched successfully',
            'count' => count($systems),
            'data' => $systems
        ]);
    }

    /**
     * Get complete doctor-grade anatomical organs dataset
     */
    public function organs(Request $request): JsonResponse
    {
        $systemFilter = $request->query('system');

        $organs = [
            'head' => [
                'id' => 'head',
                'title' => 'Brain & Central Nervous System',
                'system' => 'nervous',
                'imageUrl' => 'https://pngimg.com/d/brain_PNG20.png',
                'latin' => 'Encephalon & Systema Nervosum Centralis',
                'description' => 'The master control organ regulating cognition, sensory interpretation, memory storage, and involuntary autonomic controls.',
                'specialist' => 'Neurologist / Neurosurgeon',
                'stats' => [
                    ['value' => '1.4 kg', 'label' => 'Avg Weight', 'icon' => 'scale'],
                    ['value' => '86 Billion', 'label' => 'Neurons', 'icon' => 'psychology'],
                    ['value' => '20%', 'label' => 'Body Energy', 'icon' => 'bolt'],
                    ['value' => 'Central', 'label' => 'Command', 'icon' => 'hub'],
                ],
                'functions' => [
                    'Regulates cognitive processing & memory retention',
                    'Controls sensory perception & motor nerve output',
                    'Manages involuntary autonomic nervous functions',
                    'Coordinates body balance & neuromuscular feedback',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Cerebral cortex, Cerebellum, Brainstem (Medulla & Pons)',
                    'Innervation' => '12 Cranial Nerves (I to XII)',
                    'Blood Supply' => 'Circle of Willis (Internal Carotid & Vertebral Arteries)',
                    'Clinical Note' => 'Vulnerable to ischemic stroke, aneurysms, and neurodegenerative disorders.'
                ],
                'fact' => 'Your brain generates about 20 watts of electrical power—enough to power a small LED light bulb!'
            ],
            'eyes' => [
                'id' => 'eyes',
                'title' => 'Ocular & Sensory Visual Pathway',
                'system' => 'sensory',
                'imageUrl' => 'https://pngimg.com/d/eye_PNG35661.png',
                'latin' => 'Organum Visum & Nervus Opticus',
                'description' => 'Focuses light through cornea and lens onto 107 million photoreceptors, transmitting high-speed optic signals.',
                'specialist' => 'Ophthalmologist',
                'stats' => [
                    ['value' => '576 MP', 'label' => 'Resolution', 'icon' => 'eye'],
                    ['value' => '107 Million', 'label' => 'Photoreceptors', 'icon' => 'grain'],
                    ['value' => '2 Million', 'label' => 'Working Parts', 'icon' => 'build'],
                    ['value' => 'Retina', 'label' => 'Neural Tissue', 'icon' => 'focus'],
                ],
                'functions' => [
                    'Converts photons into high-resolution neural impulses',
                    'Regulates pupil dilation for ambient light control',
                    'Provides stereoscopic 3D depth perception',
                    'Maintains ocular fluid pressure & corneal hydration',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Cornea, Iris, Crystalline Lens, Retina, Fovea Centralis',
                    'Innervation' => 'Optic Nerve (CN II), Oculomotor (CN III), Trochlear (CN IV), Abducens (CN VI)',
                    'Blood Supply' => 'Ophthalmic Artery & Central Retinal Artery',
                    'Clinical Note' => 'Retinal detachment and glaucoma are major emergency optic conditions.'
                ],
                'fact' => 'The eye muscles are the most active muscles in your body, moving over 100,000 times a day!'
            ],
            'neck' => [
                'id' => 'neck',
                'title' => 'Cervical Spine & Pharyngeal Pathway',
                'system' => 'skeletal',
                'imageUrl' => 'https://pngimg.com/d/skeleton_PNG18.png',
                'latin' => 'Vertebrae Cervicales & Larynx',
                'description' => 'Houses 7 cervical vertebrae (C1-C7), carotid arteries, jugular veins, and the respiratory larynx assembly.',
                'specialist' => 'ENT Specialist / Orthopedic Spine Surgeon',
                'stats' => [
                    ['value' => '7 Vertebrae', 'label' => 'C1 to C7', 'icon' => 'list'],
                    ['value' => 'Carotid', 'label' => 'Arterial Blood', 'icon' => 'favorite'],
                    ['value' => 'Larynx', 'label' => 'Vocal Cords', 'icon' => 'mic'],
                    ['value' => 'Spinal Cord', 'label' => 'Nerve Trunk', 'icon' => 'route'],
                ],
                'functions' => [
                    'Supports head weight & multidirectional cervical rotation',
                    'Protects upper spinal cord nerve pathways',
                    'Facilitates arterial blood flow to the brain',
                    'Enables vocal phonation via larynx & vocal cords',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Atlas (C1), Axis (C2), C3-C7, Hyoid Bone, Vocal Folds',
                    'Innervation' => 'Cervical Plexus (C1-C4) & Vagus Nerve (CN X)',
                    'Blood Supply' => 'Common Carotid Arteries & Vertebral Arteries',
                    'Clinical Note' => 'Cervical herniated discs can compress spinal nerve roots causing radiculopathy.'
                ],
                'fact' => 'The first cervical vertebra (C1) is named "Atlas" after the Greek titan who held up the sky!'
            ],
            'thyroid' => [
                'id' => 'thyroid',
                'title' => 'Thyroid & Endocrine System',
                'system' => 'endocrine',
                'imageUrl' => 'https://pngimg.com/d/throat_PNG14.png',
                'latin' => 'Glandula Thyroidea & Systema Endocrinum',
                'description' => 'Butterfly-shaped gland producing T3/T4 hormones regulating systemic basal metabolic rate and calcium balance.',
                'specialist' => 'Endocrinologist',
                'stats' => [
                    ['value' => 'T3 & T4', 'label' => 'Hormones', 'icon' => 'science'],
                    ['value' => '20 grams', 'label' => 'Gland Weight', 'icon' => 'scale'],
                    ['value' => 'Metabolic', 'label' => 'Regulation', 'icon' => 'speed'],
                    ['value' => 'Calcitonin', 'label' => 'Calcium Control', 'icon' => 'shield'],
                ],
                'functions' => [
                    'Secretes Thyroxine (T4) & Triiodothyronine (T3)',
                    'Controls systemic oxygen consumption & heat production',
                    'Regulates heart rate & gastrointestinal motility',
                    'Balances bone calcium via calcitonin secretion',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Right & Left Lobes connected by Thyroid Isthmus',
                    'Innervation' => 'Recurrent Laryngeal Nerve & Sympathetic Trunk',
                    'Blood Supply' => 'Superior & Inferior Thyroid Arteries',
                    'Clinical Note' => 'Hypothyroidism causes fatigue and weight gain; hyperthyroidism accelerates metabolism.'
                ],
                'fact' => 'Every single cell in the human body depends upon thyroid hormones for metabolic regulation!'
            ],
            'lungs' => [
                'id' => 'lungs',
                'title' => 'Lungs & Alveolar Respiratory Tree',
                'system' => 'respiratory',
                'imageUrl' => 'https://pngimg.com/d/lungs_PNG10.png',
                'latin' => 'Pulmones & Systema Respiratorium',
                'description' => 'Facilitates continuous gas exchange across 300 million alveoli, oxygenating blood and removing carbon dioxide.',
                'specialist' => 'Pulmonologist / Chest Physician',
                'stats' => [
                    ['value' => '300 Million', 'label' => 'Alveoli', 'icon' => 'bubble'],
                    ['value' => '11,000 L', 'label' => 'Air / Day', 'icon' => 'air'],
                    ['value' => '70 m²', 'label' => 'Surface Area', 'icon' => 'aspect_ratio'],
                    ['value' => 'O₂ & CO₂', 'label' => 'Gas Exchange', 'icon' => 'swap'],
                ],
                'functions' => [
                    'Absorbs atmospheric oxygen into pulmonary capillaries',
                    'Excretes carbon dioxide gas produced by metabolism',
                    'Regulates systemic arterial blood pH balance',
                    'Filters micro-emboli from venous circulation',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Right Lung (3 Lobes), Left Lung (2 Lobes), Trachea, Bronchi',
                    'Innervation' => 'Pulmonary Plexus (Vagus & Sympathetic Nerves)',
                    'Blood Supply' => 'Pulmonary Arteries (Deoxygenated) & Bronchial Arteries',
                    'Clinical Note' => 'Pneumonia and COPD impair the oxygen diffusion capacity across alveolar walls.'
                ],
                'fact' => 'Your lungs contain roughly 2,400 kilometers of airways and a surface area equal to a tennis court!'
            ],
            'chest' => [
                'id' => 'chest',
                'title' => 'Heart & Cardiovascular Circulatory System',
                'system' => 'circulatory',
                'imageUrl' => 'https://pngimg.com/d/heart_PNG51334.png',
                'latin' => 'Cor & Systema Cardiovasculare',
                'description' => 'Four-chambered muscular pump circulating 7,500 liters of blood daily through a 100,000 km vascular network.',
                'specialist' => 'Cardiologist / Cardiothoracic Surgeon',
                'stats' => [
                    ['value' => '70-100', 'label' => 'Beats / Min', 'icon' => 'favorite'],
                    ['value' => '7,500 L', 'label' => 'Pumped / Day', 'icon' => 'water_drop'],
                    ['value' => '4 Chambers', 'label' => 'Atria & Ventricles', 'icon' => 'grid'],
                    ['value' => '100k km', 'label' => 'Vessels', 'icon' => 'route'],
                ],
                'functions' => [
                    'Propels oxygenated blood to systemic body tissues',
                    'Drives deoxygenated blood to pulmonary capillaries',
                    'Maintains arterial blood pressure & tissue perfusion',
                    'Delivers nutrients, hormones & immune antibodies',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Left/Right Atria, Left/Right Ventricles, Mitral & Aortic Valves',
                    'Innervation' => 'Sinoatrial (SA) Node & Cardiac Plexus (Vagus Nerve)',
                    'Blood Supply' => 'Right Coronary Artery & Left Anterior Descending (LAD) Artery',
                    'Clinical Note' => 'Coronary artery occlusion leads to myocardial infarction (heart attack).'
                ],
                'fact' => 'Your heart beats over 2.5 billion times in an average human lifetime without a single rest!'
            ],
            'liver' => [
                'id' => 'liver',
                'title' => 'Liver & Hepato-Biliary Filtration System',
                'system' => 'hepatic',
                'imageUrl' => 'https://pngimg.com/d/liver_PNG16.png',
                'latin' => 'Hepar & Vesica Biliaris',
                'description' => 'Primary metabolic power-factory performing 500 vital biological functions including detoxification, bile production, and glycogen storage.',
                'specialist' => 'Hepatologist / Gastroenterologist',
                'stats' => [
                    ['value' => '500+', 'label' => 'Functions', 'icon' => 'auto_awesome'],
                    ['value' => '1.5 kg', 'label' => 'Organ Weight', 'icon' => 'scale'],
                    ['value' => 'Bile', 'label' => 'Fat Digestion', 'icon' => 'water_drop'],
                    ['value' => 'Glycogen', 'label' => 'Energy Bank', 'icon' => 'battery'],
                ],
                'functions' => [
                    'Detoxifies pharmaceutical drugs & metabolic toxins',
                    'Synthesizes essential plasma proteins & clotting factors',
                    'Produces bile for intestinal lipid emulsification',
                    'Stores glucose as glycogen for emergency energy',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Right, Left, Caudate, and Quadrate Lobes, Hepatic Lobules',
                    'Innervation' => 'Celiac Plexus & Vagus Nerve',
                    'Blood Supply' => 'Hepatic Portal Vein (75%) & Hepatic Artery (25%)',
                    'Clinical Note' => 'Cirrhosis leads to portal hypertension and impaired protein synthesis.'
                ],
                'fact' => 'The liver is the only organ in the human body that can fully regenerate itself from just 25% of remaining tissue!'
            ],
            'abdomen' => [
                'id' => 'abdomen',
                'title' => 'Stomach & Gastrointestinal Digestive Tract',
                'system' => 'digestive',
                'imageUrl' => 'https://pngimg.com/d/stomach_PNG34.png',
                'latin' => 'Gaster & Intestinum Tenue / Crassum',
                'description' => 'Breaks down complex nutrients via gastric acids and digestive enzymes while absorbing essential vitamins and minerals.',
                'specialist' => 'Gastroenterologist',
                'stats' => [
                    ['value' => 'pH 1.5 - 3.5', 'label' => 'Gastric Acid', 'icon' => 'science'],
                    ['value' => '9 Meters', 'label' => 'Tract Length', 'icon' => 'straighten'],
                    ['value' => '100 Trillion', 'label' => 'Gut Microbiome', 'icon' => 'bug'],
                    ['value' => 'Peristalsis', 'label' => 'Motility', 'icon' => 'sync'],
                ],
                'functions' => [
                    'Digests proteins & food matrices via Hydrochloric Acid (HCl)',
                    'Absorbs amino acids, fatty acids, and glucose',
                    'Hosts 70% of the systemic mucosal immune system',
                    'Eliminates unabsorbed metabolic digestive waste',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Fundus, Body, Pylorus, Duodenum, Jejunum, Ileum, Colon',
                    'Innervation' => 'Enteric Nervous System (Meissner & Auerbach Plexuses)',
                    'Blood Supply' => 'Celiac Trunk & Superior/Inferior Mesenteric Arteries',
                    'Clinical Note' => 'Peptic ulcer disease occurs when gastric mucosal barriers are eroded by HCl.'
                ],
                'fact' => 'The digestive tract contains its own nervous system with over 500 million neurons—often called the second brain!'
            ],
            'kidneys' => [
                'id' => 'kidneys',
                'title' => 'Kidneys & Renal Excretory System',
                'system' => 'renal',
                'imageUrl' => 'https://pngimg.com/d/kidney_PNG28.png',
                'latin' => 'Renes & Systema Uropoeticum',
                'description' => 'Filters 180 liters of blood daily through 2 million microscopic nephrons to regulate fluid, electrolyte, and blood pressure equilibrium.',
                'specialist' => 'Nephrologist / Urologist',
                'stats' => [
                    ['value' => '2 Million', 'label' => 'Nephrons', 'icon' => 'filter'],
                    ['value' => '180 Liters', 'label' => 'Filtered / Day', 'icon' => 'water_drop'],
                    ['value' => 'Renin', 'label' => 'BP Control', 'icon' => 'speed'],
                    ['value' => 'Erythropoietin', 'label' => 'RBC Booster', 'icon' => 'water'],
                ],
                'functions' => [
                    'Filters metabolic urea & creatinine from blood',
                    'Balances systemic sodium, potassium, and pH levels',
                    'Secretes Renin enzyme to regulate blood pressure',
                    'Produces Erythropoietin to stimulate red blood cell production',
                ],
                'anatomy_details' => [
                    'Origin/Structure' => 'Renal Cortex, Renal Medulla, Glomerulus, Loop of Henle, Ureters',
                    'Innervation' => 'Renal Plexus (Sympathetic Postganglionic Fibers)',
                    'Blood Supply' => 'Renal Arteries (Receives 20% of Cardiac Output)',
                    'Clinical Note' => 'Chronic Kidney Disease (CKD) requires hemodialysis or renal transplantation.'
                ],
                'fact' => 'Your kidneys filter your entire blood volume over 40 times every single day!'
            ],
            'arms' => [
                'id' => 'arms',
                'title' => 'Upper Extremity Musculoskeletal Assembly (GetBodySmart)',
                'system' => 'muscular',
                'imageUrl' => 'https://pngimg.com/d/muscle_PNG35.png',
                'latin' => 'Biceps Brachii, Triceps Brachii & Humerus',
                'description' => 'Composed of biceps, triceps, rotator cuff, and forearm muscles supporting high precision grip and flexion force.',
                'specialist' => 'Orthopedic Surgeon / Physical Therapist',
                'stats' => [
                    ['value' => '30+ Muscles', 'label' => 'Arm & Forearm', 'icon' => 'fitness'],
                    ['value' => 'Humerus', 'label' => 'Long Bone', 'icon' => 'accessibility'],
                    ['value' => 'Full 360°', 'label' => 'Rotator Cuff', 'icon' => 'rotate'],
                    ['value' => 'Motor Power', 'label' => 'Dexterity', 'icon' => 'hand'],
                ],
                'functions' => [
                    'Drives elbow flexion & forearm supination (Biceps)',
                    'Drives elbow extension (Triceps)',
                    'Stabilizes glenohumeral shoulder articulation',
                    'Enables precision finger motor dexterity',
                ],
                'anatomy_details' => [
                    'Origin' => 'Long head: Supraglenoid tubercle; Short head: Coracoid process',
                    'Insertion' => 'Radial tuberosity and bicipital aponeurosis',
                    'Innervation' => 'Musculocutaneous Nerve (C5-C7) & Radial Nerve (C5-T1)',
                    'Action' => 'Elbow flexion, forearm supination, shoulder joint stabilization',
                    'Blood Supply' => 'Brachial Artery & Deep Brachial Artery'
                ],
                'fact' => 'The forearm contains 20 separate muscles that control every subtle articulation of your fingers!'
            ],
            'legs' => [
                'id' => 'legs',
                'title' => 'Lower Extremity Femur & Knee Joint Complex (GetBodySmart)',
                'system' => 'muscular',
                'imageUrl' => 'https://pngimg.com/d/skeleton_PNG18.png',
                'latin' => 'Quadriceps Femoris, Hamstrings & Femur',
                'description' => 'Femur, Quadriceps, Hamstrings, Patella, and cruciate ligaments providing primary locomotion power and weight bearing.',
                'specialist' => 'Rheumatologist / Orthopedic Surgeon',
                'stats' => [
                    ['value' => 'Femur', 'label' => 'Longest Bone', 'icon' => 'straighten'],
                    ['value' => 'Patella', 'label' => 'Knee Cap', 'icon' => 'shield'],
                    ['value' => '3x Body Wt', 'label' => 'Load Capacity', 'icon' => 'speed'],
                    ['value' => 'Bipedal', 'label' => 'Locomotion', 'icon' => 'walk'],
                ],
                'functions' => [
                    'Extends knee joint (Rectus Femoris & Vastus muscles)',
                    'Flexes knee joint and extends hip (Hamstrings)',
                    'Absorbs ground kinetic shock forces through knee cartilage',
                    'Drives explosive stride propulsion during walking/running',
                ],
                'anatomy_details' => [
                    'Origin' => 'Anterior inferior iliac spine & Femoral shaft',
                    'Insertion' => 'Patella and Tibial tuberosity via Patellar tendon',
                    'Innervation' => 'Femoral Nerve (L2-L4) & Sciatic Nerve (L4-S3)',
                    'Action' => 'Knee extension, hip flexion, bipedal stride stabilization',
                    'Blood Supply' => 'Femoral Artery & Deep Femoral Artery'
                ],
                'fact' => 'The femur bone in your thigh is stronger than concrete and can support up to 30 times your total body weight!'
            ]
        ];

        if ($systemFilter && $systemFilter !== 'All') {
            $filtered = array_filter($organs, function ($item) use ($systemFilter) {
                return strtolower($item['system']) === strtolower($systemFilter);
            });
            return response()->json([
                'status' => 'success',
                'system' => $systemFilter,
                'count' => count($filtered),
                'data' => array_values($filtered)
            ]);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'GetBodySmart Medical Organs & Muscles Dataset fetched successfully',
            'count' => count($organs),
            'data' => $organs
        ]);
    }
}
