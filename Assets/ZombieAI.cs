using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class ZombieAI : MonoBehaviour
{
    NavMeshAgent agent;
    NavMeshPath currentPath;

    // Start is called before the first frame update
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        agent.autoBraking = true;
        currentPath = new NavMeshPath();
    }

    // Update is called once per frame
    void Update()
    {
        if (!agent.hasPath)
        {
            agent.CalculatePath(Random.insideUnitSphere * 10 + transform.position, currentPath);
            if (currentPath.status == NavMeshPathStatus.PathComplete)
            {
                agent.SetPath(currentPath);
            }
            else
            {
                //currentPath = null;
            }
        }
        else
        {
            if (agent.remainingDistance < 0.5f)
            {
                agent.ResetPath();
                //currentPath = new NavMeshPath();
            }
        }
    }
}
