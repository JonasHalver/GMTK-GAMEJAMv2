using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelfDestruction : MonoBehaviour
{
    public float delay = 5f;
    float t = 0;


    // Update is called once per frame
    void Update()
    {
        t += Time.deltaTime;
        if (t >= delay)
        {
            Destroy(gameObject);
        }
    }

}
