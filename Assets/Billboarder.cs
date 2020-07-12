using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Billboarder : MonoBehaviour
{
    public bool facingPlayer = false;

    float dist1, dist2;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(MoveController.instance.transform);
        dist2 = dist1;
        dist1 = Vector3.Distance(transform.position, MoveController.instance.transform.position);
        facingPlayer = dist1 <= dist2;
    }
}
